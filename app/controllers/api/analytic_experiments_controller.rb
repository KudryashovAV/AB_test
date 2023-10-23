class Api::AnalyticExperimentsController < ApplicationController
  def index
    http_token = request.headers["HTTP_DEVICE_TOKEN"]

    if http_token.blank?
      render json: { error: "'Device-Token' header value is empty!" }, status: :bad_request
      return
    end

    experiment_info = ExperimentProcessor.call(http_token)

    render json: experiment_info.map { |info| { key: info.experiment_name, value: info.name } }
  end
end
