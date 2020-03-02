# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Business" do
    describe "companies" do
      refinery_login_with_devise :authentication_devise_user

      describe "show" do
        let!(:company) { FactoryBot.create(:company, :name => "A company name") }

        context "when user does not have access to the company" do
          it "should not succeed" do
            visit refinery.business_company_path(company)

            expect( page.body ).not_to have_content("A company name")
          end
        end

        context "when user does have access to the company" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL
          ]) }
          before { FactoryBot.create(:company_user, company: company, user: logged_in_user) }

          it "should succeed" do
            visit refinery.business_company_path(company)

            expect( page.body ).to have_content("A company name")
          end
        end

        context "when user is an internal user" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL
          ]) }

          it "should succeed" do
            visit refinery.business_company_path(company)

            expect( page.body ).to have_content("A company name")
          end
        end
      end
    end
  end
end
