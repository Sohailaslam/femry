Rails.application.routes.draw do

	devise_for :users, :controllers => {passwords: 'users/passwords', :registrations => "users/registrations", sessions: 'users/sessions'}
  authenticated :user do
    root 'users#new', as: :authenticated_root
  end
  get 'home/index'
  root to: "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/users/:user_id/auth/', to: 'users#aws_auth', as: 'aws_auth'
  post '/users/validate_code', to: 'users#validate_code', as: 'validate_code'


  get '/users/:user_id/password_auth/', to: 'users#password_auth', as: 'password_auth'
  post '/users/validate_password_reset_code', to: 'users#validate_password_reset_code', as: 'validate_password_reset_code'

  get 'users/index'
  resources :tasks do
  	collection do
  		put :sort
  	end
  end
  resources :users

  namespace :admin do
    root :to => "dashboard#index"
    resources :dashboard, only: :index
    resources :users
  end
end
