class ExperimentFetcher
  def self.fetch_with_options
    AnalyticExperiment.joins(:experiment_options)
                      .distinct
                      .select("analytic_experiments.id as id, key, device_count_in_experiment")
  end

  def self.fetch_unused(used_experiment_ids, date)
    AnalyticExperiment.where.not(id: used_experiment_ids).where("created_at < ?", date)
  end
end
