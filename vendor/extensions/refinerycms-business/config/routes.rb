Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :business do
    resources :billables, :only => [:index, :show, :new, :create, :update] do
      get :calendar, on: :collection
    end
    resources :bills, :only => [:index, :show]
    resources :budgets, :only => [:index, :show, :new, :create, :update]
    resources :companies, :only => [:index, :show, :new, :create] do
      resources :documents, only: [:new, :create]
      post :select, on: :member
      post :unselect, on: :collection
    end
    resources :invoices, :only => [:index, :show, :create, :update] do
      patch :add_billables, to: 'invoices#add_billables', on: :member
      post :build, on: :member
      get :statement, on: :member
    end
    resources :orders, :only => [:index, :show] do
      resources :order_items, only: [:index]
    end
    resources :plans, :only => [:index, :show, :update] do
      get :contract, on: :member
      patch :confirm, on: :member
    end
    resources :projects, :only => [:index, :show, :edit, :update, :new, :create] do
      resources :sections, only: [:create, :update]
    end
    resources :purchases, only: [:index, :new, :create, :show] do
      collection do
        match 'success', to: 'purchases#success', via: [:get, :post]
        match 'cancel', to: 'purchases#cancel', via: [:get, :post]
      end
    end
    resources :requests, :except => [:destroy] do
      member do
        get :add_document
        post :create_document
        delete 'document/:document_id', to: 'requests#destroy_document', as: :destroy_document
      end
    end
    resources :sections, :only => [:index, :show]
  end

  # Admin routes
  namespace :business, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/business" do
      resources :accounts, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :articles, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :billables, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :budgets, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :companies, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :invoices, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :number_series, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :order_items, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :orders, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :plans, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :projects, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :requests, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :sections, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
