# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Business" do
    describe "purchases" do
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

      describe "create" do
        context "when user is an external user" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL
          ]) }

          context "when trying to make a purchase with qty 0" do
            it "does not create a new Purchase" do
              pending 'Cannot test javascript requests'
              visit refinery.new_business_purchase_path

              expect{
                fill_in "purchase[qty]", :with => "0"
                click_button "Checkout"
              }.not_to change{ Refinery::Business::Purchase.count }
            end
          end
        end
      end
    end
  end
end
