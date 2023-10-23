class Admin::AnalyticExperimentsController < ApplicationController
  def index
    @analytic_experiments = ExperimentFetcher.fetch_with_options
  end

  def show
    @experiment_options = ExperimentOptionFetcher.fetch_by_experiment_id(params[:id])
  end
end
