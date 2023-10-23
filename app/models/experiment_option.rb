class ExperimentOption < ApplicationRecord
  belongs_to :analytic_experiment
  has_many :device_experiment_options, dependent: :destroy
  has_many :experiment_devices, through: :device_experiment_options, source: :device_token
end
