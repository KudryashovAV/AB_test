require "rails_helper"

describe ExperimentFetcher do
  let(:ae1) { create :analytic_experiment, key: "button_size", created_at: 2.days.ago }
  let(:ae2) { create :analytic_experiment, key: "discount", created_at: 3.days.ago }
  let(:ae3) { create :analytic_experiment, key: "button_color", created_at: 2.days.ago }

  let!(:eo1) { create :experiment_option,
                      analytic_experiment: ae2,
                      name: "10",
                      experiment_name: "discount",
                      device_count_in_option: 0,
                      device_count_in_experiment: 0,
                      limit_percentage: 60,
                      filling_percentage: 0,
                      open_for_addition: true }
  let!(:eo2) { create :experiment_option,
                      analytic_experiment: ae2,
                      name: "20",
                      experiment_name: "discount",
                      device_count_in_option: 0,
                      device_count_in_experiment: 0,
                      limit_percentage: 40,
                      filling_percentage: 0,
                      open_for_addition: true }
  let!(:eo3) { create :experiment_option,
                      analytic_experiment: ae1,
                      name: "small",
                      experiment_name: "button_size",
                      device_count_in_option: 0,
                      device_count_in_experiment: 0,
                      limit_percentage: 50.0,
                      filling_percentage: 0,
                      open_for_addition: true }
  let!(:eo4) { create :experiment_option,
                      analytic_experiment: ae1,
                      name: "large",
                      experiment_name: "button_size",
                      device_count_in_option: 0,
                      device_count_in_experiment: 0,
                      limit_percentage: 50.0,
                      filling_percentage: 0,
                      open_for_addition: true }
  let!(:eo5) { create :experiment_option,
                      analytic_experiment: ae3,
                      name: "red",
                      experiment_name: "button_color",
                      device_count_in_option: 0,
                      device_count_in_experiment: 0,
                      limit_percentage: 30.0,
                      filling_percentage: 0,
                      open_for_addition: true }
  let!(:eo6) { create :experiment_option,
                      analytic_experiment: ae3,
                      name: "black",
                      experiment_name: "button_color",
                      device_count_in_option: 0,
                      device_count_in_experiment: 0,
                      limit_percentage: 70.0,
                      filling_percentage: 0,
                      open_for_addition: true }

  context "#fetch_with_options" do
    it "return correct structure" do
      expect(described_class.fetch_with_options.map(&:attributes)).to match_array([
        { "id" => ae1.id, "key" => "button_size", "device_count_in_experiment" => 0 },
        { "id" => ae2.id, "key" => "discount", "device_count_in_experiment" => 0 },
        { "id" => ae3.id, "key" => "button_color", "device_count_in_experiment" => 0 }
      ])
    end
  end

  context "#fetch_unused" do
    it "return correct structure" do
      expect(described_class.fetch_unused([ae3.id], 2.day.ago.at_beginning_of_day)).to match_array([ae2])
    end
  end
end
