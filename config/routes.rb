# Necesita de este require para correr sidekiq web
require "sidekiq/web"

Rails.application.routes.draw do
  # Para ver bien como trabaja resources, ver video 36 del curso de Rails 5
  resources :posts
  # usuarios es como un sobrenombre de users, para poder trabajar otras acciones diferentes a las de 
  # devise
  resources :usuarios, as: :users, only: [:show, :update]
  resources :friendships, only: [:create, :update, :index]

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  post "/custom_sign_up", to: "omniauth_callbacks#custom_sign_up"

  # Devise ofrece un par de metodos que nos ayudan a gestionar si el usuario inicio sesion.
  authenticated :user do
  	root 'main#home'
  end

  unauthenticated :user do
  	root 'main#unregistered'
  end

  mount ActionCable.server => '/cable'
  mount Sidekiq::Web => '/sidekiq'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
