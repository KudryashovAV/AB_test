require "rails_helper"

describe ExperimentOptionFetcher do
  let(:ae1) { create :analytic_experiment, key: "button_size", created_at: 2.days.ago }
  let(:ae2) { create :analytic_experiment, key: "button_color", created_at: 2.days.ago }

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
                      analytic_experiment: ae1,
                      name: "small",
                      experiment_name: "button_size",
                      device_count_in_option: 0,
                      device_count_in_experiment: 0,
                      limit_percentage: 50.0,
                      filling_percentage: 0,
                      open_for_addition: true }

  context "#fetch_by_experiment_id" do
    it "return correct structure" do
      expect(described_class.fetch_by_experiment_id(ae2.id)).to match_array([eo1])
    end
  end
end
