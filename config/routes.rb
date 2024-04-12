Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'users#index'
  resources :users
  #get '/login', to: 'users#index'
  post '/sessions', to: 'sessions#create'
  post '/sessions/refresh', to: 'sessions#get_token_from_refresh'
  delete "/users", to: 'users#self_destroy'
  put "/users", to: 'users#self_update'

  ##Omniauth routes
  get '/login', to: 'omniauth#new'
  get 'auth/:provider/callback', to: 'homepage#index'

end
