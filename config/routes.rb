Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks,
                     controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  scope '(:locale)', locale: /en|vi/ do
    root 'static_pages#home'
    get '/carts', to: 'carts#index'
    get '/orders', to: 'orders#new'

    namespace :admin do
      root 'base#home'
    end

    devise_for :users, skip: :omniauth_callbacks

    devise_scope :user do
      get '/signup', to: 'devise/registrations#new'
      get '/login', to: 'devise/sessions#new'
      post '/login', to: 'devise/sessions#create'
      delete '/logout', to: 'devise/sessions#destroy'
    end

    resources :products, only: %i(show)
  end
end
