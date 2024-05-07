Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  # config/routes.rb
  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    get "up" => "rails/health#show", as: :rails_health_check

    # Defines the root path route ("/")
    #root 'users#index'
    
    resources :users
    get '/user/:id', to: 'users#show'
    get '/user/:id/settings', to: 'users#settings'
    get '/user/:id/profile', to: 'users#profile'
    patch '/users/:id/update', to: 'users#update'

    #get '/login', to: 'users#index'
    #post '/sessions', to: 'sessions#create'

    ##auth routes
    get '/auth', to: 'auth#login_or_register'
    post '/auth', to: 'auth#login_or_register'
    get '/auth/:provider/callback', to: 'omniauth#create'

    post '/auth/create_session', to: 'auth#create_session'
    post '/users/create', to: 'users#create'

    post '/users/check_username_availability', to: 'users#check_username_availability'

    get '/error', to: 'generic_error#index'

    get "/logout", to: 'auth#destroy_session'

    patch "/change_locale", to: 'users#change_locale'

    match '*unmatched', to: 'auth#login_or_register', via: :all
  end
  root to: "auth#login_or_register"

end
