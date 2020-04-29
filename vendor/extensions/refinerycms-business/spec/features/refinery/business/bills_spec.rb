# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Business" do
    describe "bills" do
      refinery_login_with_devise :authentication_devise_user

      describe "show" do
        let!(:bill) { FactoryBot.create(:bill, :invoice_number => "A bill title") }

        context "when user does not have access to the company" do
          it "should not succeed" do
            visit refinery.business_bill_path(bill)

            expect( page.body ).not_to have_content("A bill title")
            expect( page.body ).to have_content("Page not found")
          end
        end

        context "when user does have access to the company" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL
          ]) }
          before { FactoryBot.create(:company_user, company: bill.company, user: logged_in_user) }

          it "should not succeed" do
            visit refinery.business_bill_path(bill)

            expect( page.body ).not_to have_content("A bill title")
            expect( page.body ).to have_content("Page not found")
          end
        end

        context "when user is an internal user" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL
          ]) }

          it "should succeed" do
            visit refinery.business_bill_path(bill)

            expect( page.body ).not_to have_content("A bill title")
            expect( page.body ).to have_content("Page not found")
          end
        end

        context "when user is an internal finance user" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL_FINANCE
          ]) }

          it "should succeed" do
            visit refinery.business_bill_path(bill)

            expect( page.body ).to have_content("A bill title")
            expect( page.body ).not_to have_content("Page not found")
          end
        end
      end
    end
  end
end
