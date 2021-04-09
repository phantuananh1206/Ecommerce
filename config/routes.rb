Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks,
                     controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  scope '(:locale)', locale: /en|vi/ do
    root 'static_pages#home'
    get '/clear-cart', to: 'carts#clear_cart'
    post '/orders/voucher', to: 'orders#apply_voucher'
    delete '/orders/voucher', to: 'orders#cancel_voucher'
    get '/search', to: 'searchs#index'

    namespace :admin do
      root 'base#home'
      resources :orders, only: %i(index show update)
      resources :products, except: :show
      resources :categories, except: :show
    end

    devise_for :users, skip: :omniauth_callbacks

    devise_scope :user do
      get '/signup', to: 'devise/registrations#new'
      get '/login', to: 'devise/sessions#new'
      post '/login', to: 'devise/sessions#create'
      delete '/logout', to: 'devise/sessions#destroy'
    end

    resources :products, only: %i(show)
    resources :carts, except: %i(show edit new)
    resources :orders, only: %i(new create)
    resources :order_confirmations, only: %i(edit)
    resources :categories, only: %i(show)
  end
end
