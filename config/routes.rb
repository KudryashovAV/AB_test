Rails.application.routes.draw do
  namespace :api do
    resources :analytic_experiments, only: [:index]
  end

  namespace :admin do
    resources :analytic_experiments, only: %i[index show]
  end
end
