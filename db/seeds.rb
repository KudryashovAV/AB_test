DeviceToken.create([{ token: "test_token_1" }, { token: "test_token_2" }])

price_analytic_experiment = AnalyticExperiment.create(key: "price")
button_color_analytic_experiment = AnalyticExperiment.create(key: "button_color")

ExperimentOption.create([
  { analytic_experiment: price_analytic_experiment, experiment_name: price_analytic_experiment.name, name: "50", limit_percentage: 5 },
  { analytic_experiment: price_analytic_experiment, experiment_name: price_analytic_experiment.name, name: "20", limit_percentage: 10 },
  { analytic_experiment: price_analytic_experiment, experiment_name: price_analytic_experiment.name, name: "10", limit_percentage: 75 },
  { analytic_experiment: price_analytic_experiment, experiment_name: price_analytic_experiment.name, name: "5", limit_percentage: 10 },
  { analytic_experiment: button_color_analytic_experiment, experiment_name: button_color_analytic_experiment.name, name: "#FF0000", limit_percentage: 33.3 },
  { analytic_experiment: button_color_analytic_experiment, experiment_name: button_color_analytic_experiment.name, name: "#00FF00", limit_percentage: 33.3 },
  { analytic_experiment: button_color_analytic_experiment, experiment_name: button_color_analytic_experiment.name, name: "#0000FF", limit_percentage: 33.3 }
])
