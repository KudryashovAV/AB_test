require "rails_helper"

describe ExperimentProcessor do
  let(:ae1) { create :analytic_experiment, key: "button_size", created_at: 2.days.ago }
  let(:ae2) { create :analytic_experiment, key: "discount", created_at: 2.days.ago }

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
                      limit_percentage: 10,
                      filling_percentage: 0,
                      open_for_addition: true }
  let!(:eo3) { create :experiment_option,
                      analytic_experiment: ae2,
                      name: "5",
                      experiment_name: "discount",
                      device_count_in_option: 0,
                      device_count_in_experiment: 0,
                      limit_percentage: 5,
                      filling_percentage: 0,
                      open_for_addition: true }
  let!(:eo4) { create :experiment_option,
                      analytic_experiment: ae2,
                      name: "30",
                      experiment_name: "discount",
                      device_count_in_option: 0,
                      device_count_in_experiment: 0,
                      limit_percentage: 25,
                      filling_percentage: 0,
                      open_for_addition: true }
  let!(:eo5) { create :experiment_option,
                      analytic_experiment: ae1,
                      name: "small",
                      experiment_name: "button_size",
                      device_count_in_option: 0,
                      device_count_in_experiment: 0,
                      limit_percentage: 33.3,
                      filling_percentage: 0,
                      open_for_addition: true }
  let!(:eo6) { create :experiment_option,
                      analytic_experiment: ae1,
                      name: "large",
                      experiment_name: "button_size",
                      device_count_in_option: 0,
                      device_count_in_experiment: 0,
                      limit_percentage: 33.3,
                      filling_percentage: 0,
                      open_for_addition: true }
  let!(:eo7) { create :experiment_option,
                      analytic_experiment: ae1,
                      name: "medium",
                      experiment_name: "button_size",
                      device_count_in_option: 0,
                      device_count_in_experiment: 0,
                      limit_percentage: 33.3,
                      filling_percentage: 0,
                      open_for_addition: true }

  context "when experiments get a lot of requests" do
    it "returns correct structure" do
      (1..300).each do |token|
        described_class.call(token.to_s)
      end

      button_size_experiment_options =
        AnalyticExperiment.first.experiment_options.map { |x| { count_in_option: x.device_count_in_option,
                                                                count_in_experiment: x.device_count_in_experiment,
                                                                limit_percentage: x.limit_percentage,
                                                                filling_percentage: x.filling_percentage,
                                                                open_for_addition: x.open_for_addition } }

      discount_experiment_options =
        AnalyticExperiment.last.experiment_options.map { |x| { count_in_option: x.device_count_in_option,
                                                               count_in_experiment: x.device_count_in_experiment,
                                                               limit_percentage: x.limit_percentage,
                                                               filling_percentage: x.filling_percentage,
                                                               open_for_addition: x.open_for_addition } }

      expect(discount_experiment_options).to eq([{ count_in_option: 100, count_in_experiment: 300,
                                                   limit_percentage: 33.3, filling_percentage: 33.3,
                                                   open_for_addition: true },
                                                 { count_in_option: 100, count_in_experiment: 300,
                                                   limit_percentage: 33.3, filling_percentage: 33.3,
                                                   open_for_addition: true },
                                                 { count_in_option: 100, count_in_experiment: 300,
                                                   limit_percentage: 33.3, filling_percentage: 33.3,
                                                   open_for_addition: true }])

      expect(button_size_experiment_options).to eq([{ count_in_option: 178, count_in_experiment: 300,
                                                      limit_percentage: 60.0, filling_percentage: 59.3,
                                                      open_for_addition: true },
                                                    { count_in_option: 31, count_in_experiment: 300,
                                                      limit_percentage: 10.0, filling_percentage: 10.3,
                                                      open_for_addition: false },
                                                    { count_in_option: 16, count_in_experiment: 300,
                                                      limit_percentage: 5.0, filling_percentage: 5.3,
                                                      open_for_addition: false },
                                                    { count_in_option: 75, count_in_experiment: 300,
                                                      limit_percentage: 25.0, filling_percentage: 25.0,
                                                      open_for_addition: true }])
    end
  end

  context "returns correct structure" do
    def button_size_experiment_options
      AnalyticExperiment.first.experiment_options.map { |x| { count_in_option: x.device_count_in_option,
                                                              count_in_experiment: x.device_count_in_experiment,
                                                              limit_percentage: x.limit_percentage,
                                                              filling_percentage: x.filling_percentage,
                                                              open_for_addition: x.open_for_addition } }
    end

    def discount_experiment_options
      AnalyticExperiment.last.experiment_options.map { |x| { count_in_option: x.device_count_in_option,
                                                             count_in_experiment: x.device_count_in_experiment,
                                                             limit_percentage: x.limit_percentage,
                                                             filling_percentage: x.filling_percentage,
                                                             open_for_addition: x.open_for_addition } }
    end

    it "creates new device token in database" do
      expect(discount_experiment_options).to match_array([{ count_in_option: 0, count_in_experiment: 0,
                                                            limit_percentage: 33.3, filling_percentage: 0.0,
                                                            open_for_addition: true },
                                                          { count_in_option: 0, count_in_experiment: 0,
                                                            limit_percentage: 33.3, filling_percentage: 0.0,
                                                            open_for_addition: true },
                                                          { count_in_option: 0, count_in_experiment: 0,
                                                            limit_percentage: 33.3, filling_percentage: 0.0,
                                                            open_for_addition: true }])

      expect(button_size_experiment_options).to match_array([{ count_in_option: 0, count_in_experiment: 0,
                                                               limit_percentage: 60.0, filling_percentage: 0,
                                                               open_for_addition: true },
                                                             { count_in_option: 0, count_in_experiment: 0,
                                                               limit_percentage: 10.0, filling_percentage: 0.0,
                                                               open_for_addition: true },
                                                             { count_in_option: 0, count_in_experiment: 0,
                                                               limit_percentage: 5.0, filling_percentage: 0.0,
                                                               open_for_addition: true },
                                                             { count_in_option: 0, count_in_experiment: 0,
                                                               limit_percentage: 25.0, filling_percentage: 0.0,
                                                               open_for_addition: true }])

      described_class.call("1 token")

      expect(discount_experiment_options).to match_array([{ count_in_option: 1, count_in_experiment: 1,
                                                            limit_percentage: 33.3, filling_percentage: 100.0,
                                                            open_for_addition: false },
                                                          { count_in_option: 0, count_in_experiment: 1,
                                                            limit_percentage: 33.3, filling_percentage: 0.0,
                                                             open_for_addition: true },
                                                          { count_in_option: 0, count_in_experiment: 1,
                                                            limit_percentage: 33.3, filling_percentage: 0.0,
                                                            open_for_addition: true }])

      expect(button_size_experiment_options).to match_array([{ count_in_option: 1, count_in_experiment: 1,
                                                               limit_percentage: 60.0, filling_percentage: 100.0,
                                                               open_for_addition: false },
                                                             { count_in_option: 0, count_in_experiment: 1,
                                                               limit_percentage: 10.0, filling_percentage: 0.0,
                                                               open_for_addition: true },
                                                             { count_in_option: 0, count_in_experiment: 1,
                                                               limit_percentage: 5.0, filling_percentage: 0.0,
                                                               open_for_addition: true },
                                                             { count_in_option: 0, count_in_experiment: 1,
                                                               limit_percentage: 25.0, filling_percentage: 0.0,
                                                               open_for_addition: true }])

      described_class.call("2 token")

      expect(discount_experiment_options).to match_array([{ count_in_option: 1, count_in_experiment: 2,
                                                            limit_percentage: 33.3, filling_percentage: 50.0,
                                                            open_for_addition: false },
                                                          { count_in_option: 1, count_in_experiment: 2,
                                                            limit_percentage: 33.3, filling_percentage: 50.0,
                                                            open_for_addition: false },
                                                          { count_in_option: 0, count_in_experiment: 2,
                                                            limit_percentage: 33.3, filling_percentage: 0.0,
                                                            open_for_addition: true }])

      expect(button_size_experiment_options).to match_array([{ count_in_option: 1, count_in_experiment: 2,
                                                               limit_percentage: 60.0, filling_percentage: 50.0,
                                                               open_for_addition: true },
                                                             { count_in_option: 1, count_in_experiment: 2,
                                                               limit_percentage: 10.0, filling_percentage: 50.0,
                                                               open_for_addition: false },
                                                             { count_in_option: 0, count_in_experiment: 2,
                                                               limit_percentage: 5.0, filling_percentage: 0.0,
                                                               open_for_addition: true },
                                                             { count_in_option: 0, count_in_experiment: 2,
                                                               limit_percentage: 25.0, filling_percentage: 0.0,
                                                               open_for_addition: true }])

      described_class.call("3 token")

      expect(discount_experiment_options).to match_array([{ count_in_option: 1, count_in_experiment: 3,
                                                            limit_percentage: 33.3, filling_percentage: 33.3,
                                                            open_for_addition: true },
                                                          { count_in_option: 1, count_in_experiment: 3,
                                                            limit_percentage: 33.3, filling_percentage: 33.3,
                                                            open_for_addition: true },
                                                          { count_in_option: 1, count_in_experiment: 3,
                                                            limit_percentage: 33.3, filling_percentage: 33.3,
                                                            open_for_addition: true }])

      expect(button_size_experiment_options).to match_array([{ count_in_option: 1, count_in_experiment: 3,
                                                               limit_percentage: 60.0, filling_percentage: 33.3,
                                                               open_for_addition: true },
                                                             { count_in_option: 1, count_in_experiment: 3,
                                                               limit_percentage: 10.0, filling_percentage: 33.3,
                                                               open_for_addition: false },
                                                             { count_in_option: 1, count_in_experiment: 3,
                                                               limit_percentage: 5.0, filling_percentage: 33.3,
                                                               open_for_addition: false },
                                                             { count_in_option: 0, count_in_experiment: 3,
                                                               limit_percentage: 25.0, filling_percentage: 0.0,
                                                               open_for_addition: true }])

      described_class.call("4 token")

      expect(discount_experiment_options).to match_array([{ count_in_option: 2, count_in_experiment: 4,
                                                            limit_percentage: 33.3, filling_percentage: 50.0,
                                                            open_for_addition: false },
                                                          { count_in_option: 1, count_in_experiment: 4,
                                                            limit_percentage: 33.3, filling_percentage: 25.0,
                                                            open_for_addition: true },
                                                          { count_in_option: 1, count_in_experiment: 4,
                                                            limit_percentage: 33.3, filling_percentage: 25.0,
                                                            open_for_addition: true }])

      expect(button_size_experiment_options).to match_array([{ count_in_option: 1, count_in_experiment: 4,
                                                               limit_percentage: 60.0, filling_percentage: 25.0,
                                                               open_for_addition: true },
                                                             { count_in_option: 1, count_in_experiment: 4,
                                                               limit_percentage: 10.0, filling_percentage: 25.0,
                                                               open_for_addition: false },
                                                             { count_in_option: 1, count_in_experiment: 4,
                                                               limit_percentage: 5.0, filling_percentage: 25.0,
                                                               open_for_addition: false },
                                                             { count_in_option: 1, count_in_experiment: 4,
                                                               limit_percentage: 25.0, filling_percentage: 25.0,
                                                               open_for_addition: true }])

      described_class.call("5 token")

      expect(discount_experiment_options).to match_array([{ count_in_option: 2, count_in_experiment: 5,
                                                            limit_percentage: 33.3, filling_percentage: 40.0,
                                                            open_for_addition: false },
                                                          { count_in_option: 2, count_in_experiment: 5,
                                                            limit_percentage: 33.3, filling_percentage: 40.0,
                                                            open_for_addition: false },
                                                          { count_in_option: 1, count_in_experiment: 5,
                                                            limit_percentage: 33.3, filling_percentage: 20.0,
                                                            open_for_addition: true }])

      expect(button_size_experiment_options).to match_array([{ count_in_option: 2, count_in_experiment: 5,
                                                               limit_percentage: 60.0, filling_percentage: 40.0,
                                                               open_for_addition: true },
                                                             { count_in_option: 1, count_in_experiment: 5,
                                                               limit_percentage: 10.0, filling_percentage: 20.0,
                                                               open_for_addition: false },
                                                             { count_in_option: 1, count_in_experiment: 5,
                                                               limit_percentage: 5.0, filling_percentage: 20.0,
                                                               open_for_addition: false },
                                                             { count_in_option: 1, count_in_experiment: 5,
                                                               limit_percentage: 25.0, filling_percentage: 20.0,
                                                               open_for_addition: true }])
    end
  end

  context "processing stuff entities" do
    it "has to create related to token and experiment entity" do
      expect { described_class.call("token") }.to change(DeviceExperiment, :count).from(0).to(2)
    end

    it "has to create related to token and experiment option entity" do
      expect { described_class.call("token") }.to change(DeviceExperimentOption, :count).from(0).to(2)
    end
  end
end
