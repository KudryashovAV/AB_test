class DeviceToken < ApplicationRecord
  has_many :device_experiment_options, dependent: :destroy
  has_many :experiment_options, through: :device_experiment_options, source: :experiment_option
  has_many :device_experiments, dependent: :destroy
  has_many :available_experiments, through: :device_experiments, source: :analytic_experiment
end
