Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :store do
    root to: 'store#index'
    resources :orders, :only => [:index, :show]
    resources :products, :only => [:show]
    resources :retailers, :only => [:index, :show]
    resource :cart, only: [:show] do
      put 'add/:product_id', to: 'carts#add', as: :add_to
      put 'remove/:product_id', to: 'carts#remove', as: :remove_from
      post 'place_order', to: 'carts#place_order', as: :place_order
    end
  end

  # Admin routes
  namespace :store, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/store" do
      resources :orders, :except => :show do
        collection do
          post :update_positions
        end
      end
      resources :order_items, :except => :show do
        collection do
          post :update_positions
        end
      end
      resources :retailers, :except => :show do
        collection do
          post :update_positions
        end
      end
      resources :products, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
