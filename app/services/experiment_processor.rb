class ExperimentProcessor
  class << self
    def call(http_token)
      token = DeviceToken.find_or_create_by(token: http_token)
      existed_experiment_ids = token.device_experiments.pluck(:analytic_experiment_id)

      ExperimentFetcher.fetch_unused(existed_experiment_ids, token.created_at).each do |experiment|
        experiment_options = ExperimentOptionFetcher.fetch_by_experiment_id(experiment.id)

        option_for_token = experiment_options.select(&:open_for_addition)
                                             .sort_by(&:id)
                                             .min_by { |op| op.filling_percentage }
        next unless option_for_token

        ActiveRecord::Base.transaction do
          experiment_option_updater(experiment_options, option_for_token.id)
          token.device_experiment_options.create(experiment_option: option_for_token)
          token.device_experiments.create(analytic_experiment: experiment)
        end
      end

      token.reload.experiment_options.sort
    end

    private

    def experiment_option_updater(experiment_options, option_for_token_id)
      experiment_options.each do |option|
        count_in_option =
          option.id == option_for_token_id ? option.device_count_in_option + 1 : option.device_count_in_option

        current_percent = (count_in_option / (option.device_count_in_experiment.to_f + 1) * 100).round(1)

        option_data = {
          filling_percentage: current_percent,
          device_count_in_option: count_in_option,
          device_count_in_experiment: option.device_count_in_experiment + 1,
          open_for_addition: option.limit_percentage >= current_percent
        }

        option.update(option_data)
      end
    end
  end
end
