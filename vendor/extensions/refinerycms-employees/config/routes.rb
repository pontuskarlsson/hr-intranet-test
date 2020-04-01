Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :employees do
    resources :sick_leaves, :only => [:index, :new, :create, :edit, :update, :destroy] do
      member do
        get :add_note
        post :create_note
        put :extend
      end
    end
    resources :annual_leaves, :only => [:index, :create, :edit, :update, :destroy] do
      member do
        put :approve, :reject
      end
    end
    resources :employees, :only => [:index, :show]
    resources :all_leave_of_absences, :only => [:index]
    resources :chart_of_accounts, only: [:index]
    resources :expense_claims do
      resources :receipts, only: [:new, :create, :show, :edit, :update, :destroy]
      member do
        get :add_resource
        post :create_resource, :submit
        delete 'resource/:resource_id', to: 'expense_claims#destroy_resource', as: :destroy_resource
      end
    end
  end

  # Admin routes
  namespace :employees, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/employees" do
      resources :employees, :except => :show do
        collection do
          post :update_positions
        end
        member do
          post :load_xero_guids
        end
      end

      resources :sick_leaves, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :annual_leaves, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :leave_of_absences, :except => :show do
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

      resources :xero_accounts, :only => [:index, :edit, :update] do
        collection do
          post :update_positions
          post :sync_accounts
        end
      end
    end
  end

end
