Rails.application.routes.draw do

	devise_for :users, :controllers => {passwords: 'users/passwords', registrations: 'users/registrations', sessions: 'users/sessions'}
  authenticated :user do
    root 'todos#index', as: :authenticated_root
  end
  get 'home/index'
  get 'todos/index'
  get 'home/public_feed'
  post 'todos/update_deleted_column', to: 'todos#update_deleted_column', as: 'update_deleted_column'
  root to: "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/users/auth/', to: 'users#aws_auth', as: 'aws_auth'
  post '/users/validate_code', to: 'users#validate_code', as: 'validate_code'


  get '/users/:user_id/password_auth/', to: 'users#password_auth', as: 'password_auth'
  post '/users/validate_password_reset_code', to: 'users#validate_password_reset_code', as: 'validate_password_reset_code'

  get 'users/index'
  resources :tasks do
  	collection do
  		put :sort
  	end
  end
  resources :users do
    get :stats
  end
  resources :tags, only: :destroy
  namespace :admin do
    root :to => "dashboard#index"
    resources :dashboard, only: :index
    resources :users do
      member do
        get :make_premium
      end
    end
  end

  resources :thoughts, only: [:new, :update, :destroy]
  
end
