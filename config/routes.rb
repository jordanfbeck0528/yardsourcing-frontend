Rails.application.routes.draw do
  namespace :host do
    resources :dashboard, only: :index
    resources :yards, only: [:new, :create]
  end

  namespace :renter do
    resources :dashboard, only: :index
  end

  delete "/logout", to: "sessions#destroy"
end
