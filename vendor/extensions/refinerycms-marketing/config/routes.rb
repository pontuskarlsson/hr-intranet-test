Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :marketing do
    root to: 'marketing#index'

    resources :brands, :only => [:index, :show]
    resources :contacts, :only => [:index, :show]
  end

  # Admin routes
  namespace :marketing, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/marketing" do
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
      resources :contacts, :except => :show do
        collection do
          post :update_positions
          post :synchronise
        end
      end
    end
  end

end
