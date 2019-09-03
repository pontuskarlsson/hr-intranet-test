Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :quality_assurance do
    resources :inspections, :only => [:index, :show, :edit, :update]
  end

  # Admin routes
  namespace :quality_assurance, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :defects, :except => :show do
        collection do
          post :update_positions
        end
      end
      resources :inspections, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
