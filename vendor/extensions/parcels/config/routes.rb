Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :parcels do
    resources :parcels, :only => [:index, :create, :show, :update] do
      member do
        get :sign, :pass_on
      end
    end

    resources :shipments, :only => [:index, :create, :show, :update] do
    end
  end

  # Admin routes
  namespace :parcels, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/parcels" do
      resources :parcels, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
