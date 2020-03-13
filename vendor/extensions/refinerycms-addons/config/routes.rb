Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :addons do
    resources :comments, :only => [:create, :update, :destroy]
  end

  # Admin routes
  namespace :addons, :path => '' do
    namespace :admin, :path => "#{Refinery::Core.backend_route}/addons" do

    end
  end

end
