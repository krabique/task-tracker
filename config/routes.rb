Rails.application.routes.draw do
  
  resources :projects do
    resources :tasks do
      resources :comments
    end
  end
  
  devise_for :users, controllers: {
      sessions: 'users/sessions',
      passwords: 'users/passwords',
      registrations: 'users/registrations'
  }
  
  resources :users, only: [:show]
  
  root to: 'home#index'
end
