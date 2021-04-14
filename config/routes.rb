Rails.application.routes.draw do
  namespace :host do
    resources :dashboard, only: :index
    resources :yards, only: [:new, :create]
  end

  namespace :renter do
    resources :dashboard, only: :index
  end

  delete "/logout", to: "sessions#destroy"

  root 'landing_page#index'
  post '/login', to: 'users#login'
  resources :users, only: [:show]
  get '/registration', to: 'users#new'
  post '/registration', to: 'users#create'
end
