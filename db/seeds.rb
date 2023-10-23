DeviceToken.destroy_all
AnalyticExperiment.destroy_all
ExperimentOption.destroy_all
DeviceExperiment.destroy_all
DeviceExperimentOption.destroy_all

DeviceToken.create([{ token: "test_token_1" }, { token: "test_token_2" }])

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
