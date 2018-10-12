Rails.application.routes.draw do
  get 'users/index'
	devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  get 'home/index'
  root to: "home#index"

  resources :tasks
  resources :users
end
