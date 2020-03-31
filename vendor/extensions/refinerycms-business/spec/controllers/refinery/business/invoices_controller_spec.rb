require "spec_helper"

module Refinery
  module Business
    describe InvoicesController, :type => :controller do
      routes { Refinery::Core::Engine.routes }
      login_user

      describe "#statement" do
        context "when invoice is built" do
          let!(:invoice) { FactoryBot.create(:invoice_with_all_items) }

          context "when user has internal finance role" do
            let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
                ::Refinery::Business::ROLE_INTERNAL_FINANCE
            ]) }

            it "renders a pdf file" do
              get :statement, params: { id: invoice.id }, as: :pdf

              expect( response ).to have_http_status 200
            end
          end

          context "when user is external" do
            let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
                ::Refinery::Business::ROLE_EXTERNAL
            ]) }

            it "responds with page not found" do
              get :statement, params: { id: invoice.id }, as: :pdf

              expect( response ).to have_http_status 404
            end
          end
        end
      end
    end
  end
end
