Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :business do
    resources :billables, :only => [:index, :show, :new, :create, :update]
    resources :bills, :only => [:index, :show]
    resources :budgets, :only => [:index, :show, :new, :create, :update]
    resources :companies, :only => [:index, :show, :create]
    resources :invoices, :only => [:index, :show, :create, :update] do
      patch :add_billables, to: 'invoices#add_billables', on: :member
      post :build, on: :member
      get :statement, on: :member
    end
    resources :orders, :only => [:index, :show] do
      resources :order_items, only: [:index]
    end
    resources :projects, :only => [:index, :show, :edit, :update, :new, :create] do
      resources :sections, only: [:create, :update]
    end
    resources :sections, :only => [:index, :show]
  end

  # Admin routes
  namespace :business, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/business" do
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

      resources :projects, :except => :show do
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
