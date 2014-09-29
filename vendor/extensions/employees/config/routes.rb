Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :employees do
    resources :sick_leaves, :only => [:index, :create, :edit, :update]
    resources :employees, :path => '', :only => [:index, :show]
  end

  # Admin routes
  namespace :employees, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :employees, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :sick_leaves, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :employment_contracts, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :public_holidays, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
