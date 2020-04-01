# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Business" do
    describe "invoices" do
      refinery_login_with_devise :authentication_devise_user

      describe "show" do
        let!(:invoice) { FactoryBot.create(:invoice, :invoice_number => "A invoice title") }

        context "when user does not have access to the company" do
          it "should not succeed" do
            visit refinery.business_invoice_path(invoice)

            expect( page.body ).not_to have_content("A invoice title")
            expect( page.body ).to have_content("Page not found")
          end
        end

        context "when user does have access to the company" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL
          ]) }
          before { FactoryBot.create(:company_user, company: invoice.company, user: logged_in_user) }

          it "should not succeed" do
            visit refinery.business_invoice_path(invoice)

            expect( page.body ).not_to have_content("A invoice title")
            expect( page.body ).to have_content("Page not found")
          end
        end

        context "when user is an internal user" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL
          ]) }

          it "should succeed" do
            visit refinery.business_invoice_path(invoice)

            expect( page.body ).not_to have_content("A invoice title")
            expect( page.body ).to have_content("Page not found")
          end
        end

        context "when user is an internal finance user" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL_FINANCE
          ]) }

          it "should succeed" do
            visit refinery.business_invoice_path(invoice)

            expect( page.body ).to have_content("A invoice title")
            expect( page.body ).not_to have_content("Page not found")
          end

          context "when invoice have not been built and company have an active plan" do
            let!(:confirmed_plan) { FactoryBot.create(:confirmed_plan, company: invoice.company, title: "A specific monthly plan") }

            it "should prepopulate the build items form with plan content" do
              visit refinery.business_invoice_path(invoice)

              expect(page).to have_field("Plan title", with: "A specific monthly plan")
              expect(page).to have_field("Monthly Minimum Qty", with: confirmed_plan.plan_charges[0]['qty'])
              expect(page).to have_field("Article", with: confirmed_plan.plan_charges[0]['article_label'])
            end
          end
        end
      end

      describe "update" do
        context "when invoice is not managed and setting it to managed" do
          let!(:invoice) { FactoryBot.create(:invoice, :invoice_number => "A invoice title", is_managed: false) }

          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL_FINANCE
          ]) }

          it "should set to invoice to managed" do
            visit refinery.business_invoice_path(invoice)

            expect{
              click_button "Set as Managed"
            }.to change{ invoice.reload.is_managed }.from(false).to true
          end
        end
      end
    end
  end
end
