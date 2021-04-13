Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'landing_page#index'
  post '/login', to: 'users#login'
  resources :users, only: [:show]
  get '/registration', to: 'users#new'

end
