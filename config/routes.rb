Rails.application.routes.draw do
  root to: "admin/analytic_experiments#index"

  namespace :api do
    resources :analytic_experiments, only: [:index]
  end

  namespace :admin do
    resources :analytic_experiments, only: %i[index show]
  end
end
