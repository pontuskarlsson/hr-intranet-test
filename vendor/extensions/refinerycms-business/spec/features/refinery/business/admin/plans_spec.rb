# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Business" do
    describe "Admin" do
      describe "plans" do
        refinery_login

        describe "plans list" do
          before do
            FactoryBot.create(:plan, :title => "UniqueTitleOne")
            FactoryBot.create(:plan, :title => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.business_admin_plans_path
            expect( page ).to have_content("UniqueTitleOne")
            expect( page ).to have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          let!(:company) { FactoryBot.create(:verified_company) }
          let!(:account) { FactoryBot.create(:account) }
          let!(:contact_person) {
            FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
                ::Refinery::Business::ROLE_EXTERNAL
            ])
          }
          let!(:account_manager) {
            FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
                ::Refinery::Business::ROLE_INTERNAL
            ])
          }

          before do
            FactoryBot.create(:company_user, company: company, user: contact_person)
          end

          before do
            visit refinery.business_admin_plans_path

            click_link "Add New Plan"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Company", :with => company.label
              fill_in "Contact Person", :with => contact_person.label
              fill_in "Account Manager", :with => account_manager.label
              select account.organisation, :from => "Account"
              select 'USD', :from => "Currency code"
              fill_in "Title", :with => "My Monthly Plan"
              click_button "Save"

              expect( page ).to have_content("was successfully added.")
              expect( Refinery::Business::Plan.count ).to eq 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              expect( page ).to have_content("Company can't be blank")
              expect( Refinery::Business::Plan.count ).to eq 0
            end
          end

        end

        describe "edit" do
          before { FactoryBot.create(:plan, :title => "A plan title") }

          it "should succeed" do
            visit refinery.business_admin_plans_path

            within ".actions" do
              click_link "Edit this plan"
            end

            fill_in "Title", :with => "A different plan title"
            click_button "Save"

            expect( page ).to have_content("was successfully updated.")
            expect( page ).to have_no_content("A plan title")
          end
        end

        describe "destroy" do
          before { FactoryBot.create(:plan, :description => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.business_admin_plans_path

            click_link "Remove this plan forever"

            expect( page ).to have_content("was successfully removed.")
            expect( Refinery::Business::Plan.count ).to eq 0
          end
        end

      end
    end
  end
end
