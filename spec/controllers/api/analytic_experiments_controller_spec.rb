require "rails_helper"

describe Api::AnalyticExperimentsController, type: :controller do
  context "invalid request when header does not provided" do
    it "has bad request status and message" do
      get :index
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)).to eq({ "error" => "'Device-Token' header value is empty!" })
    end
  end

  context "with many customers" do
    let!(:seed) do
      price_analytic_experiment = AnalyticExperiment.create(key: "price")
      button_color_analytic_experiment = AnalyticExperiment.create(key: "button_color")
      ExperimentOption.create([
        { analytic_experiment: price_analytic_experiment, experiment_name: price_analytic_experiment.key, name: "50", limit_percentage: 5 },
        { analytic_experiment: price_analytic_experiment, experiment_name: price_analytic_experiment.key, name: "20", limit_percentage: 10 },
        { analytic_experiment: price_analytic_experiment, experiment_name: price_analytic_experiment.key, name: "10", limit_percentage: 75 },
        { analytic_experiment: price_analytic_experiment, experiment_name: price_analytic_experiment.key, name: "5", limit_percentage: 10 },
        { analytic_experiment: button_color_analytic_experiment, experiment_name: button_color_analytic_experiment.key, name: "#FF0000", limit_percentage: 33.3 },
        { analytic_experiment: button_color_analytic_experiment, experiment_name: button_color_analytic_experiment.key, name: "#00FF00", limit_percentage: 33.3 },
        { analytic_experiment: button_color_analytic_experiment, experiment_name: button_color_analytic_experiment.key, name: "#0000FF", limit_percentage: 33.3 }
      ])
    end

    it "creates corresponding count of price values" do
      settings = Parallel.map((1..100).to_a, :in_ractor => 8) do |i|
        request.headers.merge!("Device-Token" => SecureRandom.uuid); get :index; JSON.parse(response.body)
      end
      result = settings.group_by{|resp| resp.detect{|exp| exp["key"] == "price"}["value"]}.transform_values(&:size)
      expect(result).to be_eql({"10"=> 75, "20" => 10, "50" => 5, "5"=> 10})
    end

    it "creates corresponding count of button_color values" do
      settings = Parallel.map((1..99).to_a, :in_ractor => 8) do
        request.headers.merge!("Device-Token" => SecureRandom.uuid); get :index; JSON.parse(response.body)
      end
      result = settings.group_by{|resp| resp.detect{|exp| exp["key"] == "button_color"}["value"]}.transform_values(&:size)
      expect(result).to be_eql({'#FF0000'=> 33, '#00FF00' => 33, '#0000FF' => 33})
    end
  end

  context "valid request" do
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

    context "when the device token is older than experiments" do
      let(:device_token) { create :device_token, token: "4568235534855493snow15john", created_at: 2.day.ago }
      let!(:ae1) { create :analytic_experiment, key: "button_size", created_at: 1.days.ago }
      let!(:ae2) { create :analytic_experiment, key: "discount", created_at: 1.days.ago }

      it "returns empty array" do
        request.headers.merge!(HTTP_DEVICE_TOKEN: device_token.token)
        get :index
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context "when the device token is younger than experiments" do
      let(:device_token) { create :device_token, token: "4568235534855493snow15john", created_at: 1.day.ago }
      let(:ae1) { create :analytic_experiment, key: "button_size", created_at: 2.days.ago }
      let(:ae2) { create :analytic_experiment, key: "discount", created_at: 2.days.ago }

      it "returns variants for device" do
        request.headers.merge!(HTTP_DEVICE_TOKEN: device_token.token)
        get :index
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq([ { "key"=>"discount", "value"=>"10" },
                                                  { "key"=>"button_size", "value"=>"small" } ])
      end
    end

    context "when the device token is not exist in database" do
      let(:ae1) { create :analytic_experiment, key: "button_size", created_at: 2.days.ago }
      let(:ae2) { create :analytic_experiment, key: "discount", created_at: 2.days.ago }

      it "creates new device token in database" do
        request.headers.merge!(HTTP_DEVICE_TOKEN: "new_token")

        expect { get(:index) }.to change(DeviceToken, :count).from(0).to(1)
      end

      it "returns variants for new device" do
        request.headers.merge!(HTTP_DEVICE_TOKEN: "new_token")
        get :index
        expect(JSON.parse(response.body)).to eq([ { "key"=>"discount", "value"=>"10" },
                                                  { "key"=>"button_size", "value"=>"small" } ])
      end
    end

    context "returns correct structure" do
      let(:ae1) { create :analytic_experiment, key: "button_size", created_at: 2.days.ago }
      let(:ae2) { create :analytic_experiment, key: "discount", created_at: 2.days.ago }

      it "creates new device token in database" do
        request.headers.merge!(HTTP_DEVICE_TOKEN: "1 token")
        get :index
        expect(JSON.parse(response.body)).to eq([ { "key"=>"discount", "value"=>"10" },
                                                  { "key"=>"button_size", "value"=>"small" } ])

        request.headers.merge!(HTTP_DEVICE_TOKEN: "2 token")
        get :index
        expect(JSON.parse(response.body)).to eq([ { "key"=>"discount", "value"=>"20" },
                                                  { "key"=>"button_size", "value"=>"large" } ])

        request.headers.merge!(HTTP_DEVICE_TOKEN: "3 token")
        get :index
        expect(JSON.parse(response.body)).to eq([ { "key"=>"discount", "value"=>"5" },
                                                  { "key"=>"button_size", "value"=>"medium" } ])

        request.headers.merge!(HTTP_DEVICE_TOKEN: "4 token")
        get :index
        expect(JSON.parse(response.body)).to eq([ { "key"=>"discount", "value"=>"30" },
                                                  { "key"=>"button_size", "value"=>"small" } ])

        request.headers.merge!(HTTP_DEVICE_TOKEN: "5 token")
        get :index
        expect(JSON.parse(response.body)).to eq([ { "key"=>"discount", "value"=>"10" },
                                                  { "key"=>"button_size", "value"=>"large" } ])
      end
    end

    context "when request with the same device token" do
      let(:ae1) { create :analytic_experiment, key: "button_size", created_at: 2.days.ago }
      let(:ae2) { create :analytic_experiment, key: "discount", created_at: 2.days.ago }

      it "creates new device token in database" do
        request.headers.merge!(HTTP_DEVICE_TOKEN: "new_token")

        expect { get(:index) }.to change(DeviceToken, :count).from(0).to(1)
        expect(JSON.parse(response.body)).to eq([ { "key"=>"discount", "value"=>"10" },
                                                  { "key"=>"button_size", "value"=>"small" } ])

        request.headers.merge!(HTTP_DEVICE_TOKEN: "new_token")

        expect { get(:index) }.to_not change(DeviceToken, :count)
        expect(JSON.parse(response.body)).to eq([ { "key"=>"discount", "value"=>"10" },
                                                  { "key"=>"button_size", "value"=>"small" } ])

        request.headers.merge!(HTTP_DEVICE_TOKEN: "new_token")

        expect { get(:index) }.to_not change(DeviceToken, :count)
        expect(JSON.parse(response.body)).to eq([ { "key"=>"discount", "value"=>"10" },
                                                  { "key"=>"button_size", "value"=>"small" } ])
      end
    end
  end
end
