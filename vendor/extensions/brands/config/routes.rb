Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :brands do
    resources :brands, :path => '', :only => [:index, :show]
  end

  # Admin routes
  namespace :brands, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :brands, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :shows, :except => :show do
        collection do
          post :update_positions
        end
        member do
          post :sync
        end
      end
    end
  end

end
