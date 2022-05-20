Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchant_search#show'
      get '/items/find_all', to: 'item_search#index'
      namespace :merchants do
        resources :most_items, only: [:index]
      end
      resources :merchants, only: [:index, :show] do
        resources :items, controller: 'merchant_items', only: [:index]
      end
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resources :merchant, controller: 'item_merchants' 
      end
      namespace :revenue do
        resources :merchants, only: [:index, :show]
        resources :items, only: [:index]
      end
      resources :revenue, only: [:index]
    end
  end
end
