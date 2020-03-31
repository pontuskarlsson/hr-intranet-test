# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Business" do
    describe "plans" do
      refinery_login_with_devise :authentication_devise_user

      describe "new" do
        context "when user is an external user" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL
          ]) }

          it "should succeed" do
            visit refinery.new_business_purchase_path
            expect( page.body ).to have_content("Selected Items")
          end
        end

        context "when user is an internal user" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL
          ]) }

          it "should succeed" do
            visit refinery.new_business_purchase_path

            expect( page.body ).to have_content("Selected Items")
          end
        end
      end
    end
  end
end
