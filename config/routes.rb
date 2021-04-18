Rails.application.routes.draw do
  root 'landing_page#index'
  get "/auth/google_oauth2/callback", to: 'sessions#create'
  get "/auth/failure", to: 'sessions#bad'
  delete "/logout", to: "sessions#destroy"

  namespace :host do
    resources :dashboard, only: :index
    resources :yards, only: [:new, :create, :show]
  end

  resources :yards, only: [:show]

  namespace :renter do
    resources :dashboard, only: :index
  end
end
