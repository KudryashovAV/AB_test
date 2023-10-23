require File.expand_path("../../config/environment", __FILE__)

require "database_cleaner/active_record"

Rails.env = "test"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.before(:suite) do
    ActiveRecord::Base.establish_connection(Rails.env.to_sym)
    DatabaseCleaner[:active_record, db: :analytic_experiment_test].clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner[:active_record, db: :analytic_experiment_test].clean
  end

  config.include FactoryBot::Syntax::Methods

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
