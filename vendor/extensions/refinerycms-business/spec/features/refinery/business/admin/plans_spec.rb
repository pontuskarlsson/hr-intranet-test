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
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.business_admin_plans_path

            click_link "Add New Plan"
          end

          context "valid data" do
            let(:company) { FactoryBot.create(:company) }
            let(:account) { FactoryBot.create(:account) }
            before { company; account }

            it "should succeed" do
              click_link "Add New Plan" # Click link again after account has been created

              fill_in "Company", :with => company.label
              select account.organisation, :from => "Account"
              fill_in "Title", :with => "My Monthly Plan"
              click_button "Save"

              page.should have_content("was successfully added.")
              Refinery::Business::Plan.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Company can't be blank")
              Refinery::Business::Plan.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryBot.create(:plan, :description => "UniqueTitle") }

            it "should fail" do
              pending "Duplication is not checked at this time"
              visit refinery.business_admin_plans_path

              click_link "Add New Plan"

              fill_in "Description", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Business::Plan.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryBot.create(:plan, :description => "A order_id") }

          it "should succeed" do
            visit refinery.business_admin_plans_path

            within ".actions" do
              click_link "Edit this plan"
            end

            fill_in "Description", :with => "A different order_id"
            click_button "Save"

            page.should have_content("was successfully updated.")
            page.should have_no_content("A order_id")
          end
        end

        describe "destroy" do
          before { FactoryBot.create(:plan, :description => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.business_admin_plans_path

            click_link "Remove this plan forever"

            page.should have_content("was successfully removed.")
            Refinery::Business::Plan.count.should == 0
          end
        end

      end
    end
  end
end
