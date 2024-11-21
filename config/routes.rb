Rails.application.routes.draw do

  # WebSocket for ActionCable (real-time updates)
  mount ActionCable.server => '/cable' # This will handle WebSocket connections
  # get 'games/index'
  # get 'games/new'
  # get 'games/create'
  # get 'games/show'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  # config/routes.rb
  root to: "auth#login_or_register"
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


    get '/error', to: 'generic_error#index'

    get "/logout", to: 'auth#destroy_session'

    #patch "/change_locale", to: 'users#change_locale'
    patch "/user/:id/save_settings", to: 'users#save_settings'



    #get "/user/:id/friends", to: 'friends#show'
    get "/user/:id/friends/search_users", to: 'friends#index_users'
    get "/user/:id/friends/search_sent", to: 'friends#index_sent'
    get "/user/:id/friends/search_received", to: 'friends#index_received'
    get "/user/:id/friends", to: 'friends#index'

    get  "/user/:id/games" , to: 'games#index'
    get  "/user/:id/games/create" , to: 'games#create'
    get  "/user/:id/games/:gameId" , to: 'games#show'
    get '/user/:id/games/:gameId/select_character/:player', to: 'games#select_character'

  end
  post  "/games/new" , to: 'games#new'
  post  "/games/:gameId/save_selected_character" , to: 'games#save_selected_character'
  post  "/games/:gameId/save_discarded_characters" , to: 'games#save_discarded_characters'
  post  "/games/:gameId/is_answer_correct" , to: 'games#is_answer_correct'
  post  "/games/:gameId/toggle_round", to: 'games#toggle_round'

  post '/users/check_username_availability', to: 'users#check_username_availability'
  post '/friends/create', to: 'friends#create'
  post "/friends/delete", to: 'friends#delete'
  patch "/friends/accept", to: 'friends#accept'
  get "/friends/search_users(/:search_query)", to: 'friends#search_users'
  get "/friends/search_sent(/:search_query)", to: 'friends#search_sent'
  get "/friends/search_received(/:search_query)", to: 'friends#search_received'
  get "/friends/search_friends(/:search_query)", to: 'friends#search_friends'
  match '*unmatched', to: 'auth#login_or_register', via: :all
end
