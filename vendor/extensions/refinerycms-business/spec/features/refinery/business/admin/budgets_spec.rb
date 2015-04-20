# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Business" do
    describe "Admin" do
      describe "budgets" do
        refinery_login_with :refinery_user

        describe "budgets list" do
          before do
            FactoryGirl.create(:budget, :description => "UniqueTitleOne")
            FactoryGirl.create(:budget, :description => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.business_admin_budgets_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.business_admin_budgets_path

            click_link "Add New Budget"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Description", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Business::Budget.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Description can't be blank")
              Refinery::Business::Budget.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:budget, :description => "UniqueTitle") }

            it "should fail" do
              visit refinery.business_admin_budgets_path

              click_link "Add New Budget"

              fill_in "Description", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Business::Budget.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:budget, :description => "A order_id") }

          it "should succeed" do
            visit refinery.business_admin_budgets_path

            within ".actions" do
              click_link "Edit this budget"
            end

            fill_in "Description", :with => "A different order_id"
            click_button "Save"

            page.should have_content("'A different order_id' was successfully updated.")
            page.should have_no_content("A order_id")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:budget, :description => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.business_admin_budgets_path

            click_link "Remove this budget forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Business::Budget.count.should == 0
          end
        end

      end
    end
  end
end
