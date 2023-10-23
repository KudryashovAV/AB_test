class DeviceExperimentOption < ApplicationRecord
  belongs_to :experiment_option
  belongs_to :device_token
end
