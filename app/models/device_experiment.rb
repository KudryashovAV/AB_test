class DeviceExperiment < ApplicationRecord
  belongs_to :analytic_experiment
  belongs_to :device_token
end
