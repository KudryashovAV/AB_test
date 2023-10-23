FactoryBot.define do
  factory :device_experiment_option do
    association :experiment_option
    association :device_token
  end
end
