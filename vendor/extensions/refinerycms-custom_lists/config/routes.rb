Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :custom_lists do
    resources :custom_lists, :path => '', :only => [:index, :show]
  end

  # Admin routes
  namespace :custom_lists, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :custom_lists, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :list_columns, :except => :show do
        collection do
          post :update_positions
        end
      end
    end

    resources :custom_lists, only: [] do
      resources :list_rows, only: [:create, :edit, :update, :destroy]
    end
  end

end
