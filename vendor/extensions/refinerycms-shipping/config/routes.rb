Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :shipping do
    resources :parcels, :only => [:index, :create, :show, :update] do
      member do
        get :sign, :pass_on
      end
    end

    resources :shipments, :only => [:index, :create, :show, :edit, :update, :destroy] do
      patch :manual_ship, on: :member
      member do
        get :add_document
        post :create_document
        delete 'document/:document_id', to: 'shipments#destroy_document', as: :destroy_document
        get :locations
      end
      resources :packages, only: [:create, :update, :destroy]
    end
  end

  # Admin routes
  namespace :shipping, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/shipping" do
      resources :routes, :except => :show do
        collection do
          post :update_positions
        end
      end
      resources :items, :except => :show do
        collection do
          post :update_positions
        end
      end
      resources :locations, :except => :show do
        collection do
          post :update_positions
        end
      end
      resources :parcels, :except => :show do
        collection do
          post :update_positions
        end
      end
      resources :shipments, :except => :show do
        collection do
          post :update_positions
        end
      end
      resources :packages, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
