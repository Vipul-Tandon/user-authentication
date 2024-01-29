Rails.application.routes.draw do
  post '/register', to: 'users#create'
  post '/login', to: 'authentication#login'
  post '/logout', to: 'authentication#logout'

  get '/users', to: 'users#index'
end
