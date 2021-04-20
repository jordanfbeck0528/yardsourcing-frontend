Rails.application.routes.draw do
  root 'landing_page#index'
  get "/auth/google_oauth2/callback", to: 'sessions#create'
  get "/auth/failure", to: 'sessions#bad'
  delete "/logout", to: "sessions#destroy"

  namespace :host do
    resources :dashboard, only: :index
    resources :yards, except: [:show, :destroy]
  end

  get 'search/yards', to: 'search#find_yards'
  resources :search, only: [:index]

  resources :yards, only: [:show] do
    resources :bookings, only: [:new, :create]
  end

  namespace :renter do
    resources :dashboard, only: :index
  end

  resources :yards, only: :show
end
