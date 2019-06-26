Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :business do
    resources :budgets, :only => [:index, :show, :new, :create, :update]
    resources :companies, :only => [:index, :show, :create]
    resources :invoices, :only => [:index, :show]
    resources :projects, :only => [:index, :show, :new, :create]
    resources :sales_orders, :only => [:index, :show]
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

      resources :sales_orders, :except => :show do
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
