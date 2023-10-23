class AnalyticExperiment < ApplicationRecord
  has_many :experiment_options, dependent: :destroy
  has_many :device_experiments, dependent: :destroy
  has_many :involved_devices, through: :device_experiments, source: :device_token
end
