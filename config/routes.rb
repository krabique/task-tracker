# frozen_string_literal: true

Rails.application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'

  resources :projects do
    resources :tasks do
      resources :comments
    end
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :users, only: [:show]

  root to: 'home#index'
end
