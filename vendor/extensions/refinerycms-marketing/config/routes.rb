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

      resources :campaigns, :except => :show

      resources :contacts, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :landing_pages, :except => :show
      resources :shows, :except => :show
    end

    get '*landing_page_slug', to: 'landing_pages#show',
                              as: :landing_page,
                              constraints: -> (req) { ::Refinery::Marketing::LandingPage.where(slug: req.path).exists? }
  end

end
