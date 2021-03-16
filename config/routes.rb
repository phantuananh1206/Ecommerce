Rails.application.routes.draw do
  scope '(:locale)', locale: /en|vi/ do
    root 'static_pages#home'
    get '/products', to: 'products#show'
    get '/carts', to: 'carts#index'
    get '/orders', to: 'orders#new'

    namespace :admin do
      root 'base#home'
    end
  end
end
