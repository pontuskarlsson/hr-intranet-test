Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :business do
    resources :sales_orders, :only => [:index, :show]
    resources :budgets, :only => [:index, :show, :new, :create, :update]
  end

  # Admin routes
  namespace :business, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/business" do
      resources :sales_orders, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :budgets, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
