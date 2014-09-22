Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :sales_orders do
    resources :sales_orders, :path => '', :only => [:index, :show]
  end

  # Admin routes
  namespace :sales_orders, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :sales_orders, :except => :show do
        collection do
          post :update_positions
          post :import
        end
      end
    end
  end

end
