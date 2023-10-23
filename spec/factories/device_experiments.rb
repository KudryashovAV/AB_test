FactoryBot.define do
  factory :device_experiment do
    association :analytic_experiment
    association :device_token
  end
end
