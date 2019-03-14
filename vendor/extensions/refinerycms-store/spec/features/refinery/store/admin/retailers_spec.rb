# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Store" do
    describe "Admin" do
      describe "retailers" do
        refinery_login_with_devise :refinery_user

        describe "retailers list" do
          before do
            FactoryGirl.create(:retailer, :name => "UniqueTitleOne")
            FactoryGirl.create(:retailer, :name => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.store_admin_retailers_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.store_admin_retailers_path

            click_link "Add New Retailer"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Name", :with => "This is a test of the first string field"
              fill_in "Default Price Unit", :with => "HKD"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Store::Retailer.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Name can't be blank")
              Refinery::Store::Retailer.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:retailer, :name => "UniqueTitle") }

            it "should fail" do
              visit refinery.store_admin_retailers_path

              click_link "Add New Retailer"

              fill_in "Name", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Store::Retailer.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:retailer, :name => "A name") }

          it "should succeed" do
            visit refinery.store_admin_retailers_path

            within ".actions" do
              click_link "Edit this retailer"
            end

            fill_in "Name", :with => "A different name"
            click_button "Save"

            page.should have_content("'A different name' was successfully updated.")
            page.should have_no_content("A name")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:retailer, :name => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.store_admin_retailers_path

            click_link "Remove this retailer forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Store::Retailer.count.should == 0
          end
        end

      end
    end
  end
end
