# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Business" do
    describe "plans" do
      refinery_login_with_devise :authentication_devise_user

      describe "show" do
        let!(:plan) { FactoryBot.create(:plan, :title => "A plan title") }

        context "when user does not have access to the company" do
          it "should not succeed" do
            visit refinery.business_plan_path(plan)

            expect( page.body ).not_to have_content("A plan title")
          end
        end

        context "when user does have access to the company" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_EXTERNAL
          ]) }
          before { FactoryBot.create(:company_user, company: plan.company, user: logged_in_user) }

          it "should succeed" do
            visit refinery.business_plan_path(plan)

            expect( page.body ).to have_content("A plan title")
          end

          context "when the status is proposed and the proposal_valid_until is an upcoming date" do
            let!(:plan) { FactoryBot.create(:proposed_plan, :proposal_valid_until => 1.month.from_now) }

            it "should succeed" do
              visit refinery.business_plan_path(plan)

              expect( page.body ).to have_content("Proposed")
              expect( page.body ).not_to have_content("Expired")
              expect( page.body ).to have_button("Accept")
            end
          end

          context "when the status is proposed and the proposal_valid_until is a past date" do
            let!(:plan) { FactoryBot.create(:proposed_plan, :proposal_valid_until => 1.month.ago) }

            it "should succeed" do
              visit refinery.business_plan_path(plan)

              expect( page.body ).to have_content("Proposed")
              expect( page.body ).to have_content("Expired")
              expect( page.body ).not_to have_button("Accept")
            end
          end
        end

        context "when user is an internal user" do
          let!(:logged_in_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL
          ]) }

          it "should succeed" do
            visit refinery.business_plan_path(plan)

            expect( page.body ).to have_content("A plan title")
          end
        end
      end
    end
  end
end
