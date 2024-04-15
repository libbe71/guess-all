Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  #root 'users#index'
  root 'homepage#index'
  resources :users
  #get '/login', to: 'users#index'
  #post '/sessions', to: 'sessions#create'

  ##auth routes
  get '/auth', to: 'auth#login_or_register'
  post '/auth', to: 'auth#login_or_register'
  get 'auth/:provider/callback', to: 'omniauth#create'

  post '/auth/create_session', to: 'auth#create_session'
  post '/users/create', to: 'users#create'


end
