Rails.application.routes.draw do
	devise_for :users, :controllers => {:registrations => "users/registrations", sessions: 'users/sessions'}
  get 'home/index'
  root to: "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/users/:user_id/auth/', to: 'users#aws_auth', as: 'aws_auth'
  post '/users/validate_code', to: 'users#validate_code', as: 'validate_code'

  get 'users/index'
  resources :tasks do
  	collection do
  		put :sort
  	end
  end
  resources :users
end
