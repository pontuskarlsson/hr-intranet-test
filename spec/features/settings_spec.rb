# encoding: utf-8
require "spec_helper"

describe "settings" do
  describe "show" do
    refinery_login_with_devise :authentication_devise_user

    let!(:company) { FactoryBot.create(:verified_company) }

    context "when user does have access to the company" do
      let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
          ::Refinery::Business::ROLE_EXTERNAL
      ]) }
      before { FactoryBot.create(:company_user, company: company, user: logged_in_user) }

      it "should succeed" do
        visit setting_path(company)

        expect( page.body ).to have_content("Company Details")
        expect( page.body ).not_to have_content("Page not found")
      end
    end
  end
end
