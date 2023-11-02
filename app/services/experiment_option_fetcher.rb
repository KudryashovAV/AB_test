class ExperimentOptionFetcher
  def self.fetch_by_experiment_id(id)
    ExperimentOption.lock.where(analytic_experiment_id: id).order(:id)
  end
end
