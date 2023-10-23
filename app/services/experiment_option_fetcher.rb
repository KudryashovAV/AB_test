class ExperimentOptionFetcher
  def self.fetch_by_experiment_id(id)
    ExperimentOption.where(analytic_experiment_id: id)
  end
end
