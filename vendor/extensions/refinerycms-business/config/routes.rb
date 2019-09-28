Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :business do
    resources :billables, :only => [:index, :show, :new, :create, :update]
    resources :budgets, :only => [:index, :show, :new, :create, :update]
    resources :companies, :only => [:index, :show, :create]
    resources :invoices, :only => [:index, :show] do
      patch :add_billables, to: 'invoices#add_billables', on: :member
    end
    resources :projects, :only => [:index, :show, :new, :create] do
      get :archive, on: :collection
      resources :sections, only: [:create, :update]
    end
    resources :sections, :only => [:index, :show]
  end

  # Admin routes
  namespace :business, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/business" do
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
