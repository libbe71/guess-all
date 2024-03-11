Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "login#index"
  get '/login_or_register', to: 'login#index'
  post '/login_or_register', to: 'sessions#create'
  resources :users
  #get "/login", to: "login#index"
  #get "/homepage", to: "homepage#index"
  #get "/homepage/user/:id", to: "homepage#show"
end
