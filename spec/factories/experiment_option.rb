FactoryBot.define do
  factory :experiment_option do
    name { "red" }
    experiment_name { "placeholder color" }
    device_count_in_option { 2 }
    device_count_in_experiment { 10 }
    limit_percentage { 50 }
    filling_percentage { 20 }
    open_for_addition { true }

    association :analytic_experiment
  end
end
