Refinery::Core::Engine.routes.append do

  # Frontend routes
  namespace :calendar do
    get 'events/archive' => 'events#archive'
    resources :events, :only => [:index, :show, :new, :create, :update, :destroy]
    resources :user_calendars, only: [:create]
  end

  # Admin routes
  namespace :calendar, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/calendar" do
      resources :events, :except => :show do
        collection do
          post :update_positions
        end
      end
      resources :venues, :except => :show do
        collection do
          post :update_positions
        end
      end
      resources :calendars, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
