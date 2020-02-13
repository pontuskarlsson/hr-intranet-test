module Refinery
  module Authentication
    module Devise
      module FeatureMacros

        def refinery_login
          # Create a user with Refinery permissions and login that user
          refinery_login_with_devise(:authentication_devise_refinery_user)
        end

        def refinery_login_with_devise(factory)
          let!(:logged_in_user) { FactoryBot.create(factory) }

          # Check if after the :logged_in_user is created, there is any "Refinery User" (User with the Refinery role).
          # Create one if not any present. Otherwise all requests will be redirected to create an initial User.
          before do
            unless Refinery::Authentication::Devise::Role[:refinery].users.any?
              FactoryBot.create(:authentication_devise_refinery_user) # Factory from 'refinerycms-authentication-devise'
            end
          end

          before do
            visit refinery.login_path
            within "#panelLogin" do
              fill_in "Username or email", with: logged_in_user.username
              fill_in "Password", with: "refinerycms"

              click_button "Sign in"
            end
          end
        end

      end
    end
  end
end

RSpec.configure do |config|
  config.extend Refinery::Authentication::Devise::FeatureMacros, type: :feature
end
