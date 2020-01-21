# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Shipping" do
    describe "Admin" do
      describe "locations" do
        refinery_login_with_devise :authentication_devise_user

        describe "locations list" do
          before do
            FactoryBot.create(:location, :from_name => "UniqueTitleOne")
            FactoryBot.create(:location, :from_name => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.shipping_admin_locations_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          let(:authentication_devise_user) { FactoryBot.create(:authentication_devise_user) }
          before do
            authentication_devise_user # Creates one record before loading form

            visit refinery.shipping_admin_locations_path

            click_link "Add New Location"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "From", :with => "This is a test of the first string field"
              fill_in "Location Date", :with => "2014-01-01"
              fill_in "Courier", :with => "Express Courier"
              fill_in "To", :with => "John Doe"
              select authentication_devise_user.username, :from => "Received by"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Shipping::Location.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("From Name can't be blank")
              Refinery::Shipping::Location.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryBot.create(:location, :from_name => "UniqueTitle") }

            it "should fail" do
              visit refinery.shipping_admin_locations_path

              click_link "Add New Location"

              fill_in "From", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Shipping::Location.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryBot.create(:location, :from_name => "A from_name") }

          it "should succeed" do
            visit refinery.shipping_admin_locations_path

            within ".actions" do
              click_link "Edit this location"
            end

            fill_in "From", :with => "A different from_name"
            click_button "Save"

            page.should have_content("'A different from_name' was successfully updated.")
            page.should have_no_content("A from_name")
          end
        end

        describe "destroy" do
          before { FactoryBot.create(:location, :from_name => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.shipping_admin_locations_path

            click_link "Remove this location forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Shipping::Location.count.should == 0
          end
        end

      end
    end
  end
end
