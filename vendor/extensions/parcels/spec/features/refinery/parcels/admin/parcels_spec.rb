# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Parcels" do
    describe "Admin" do
      describe "parcels" do
        refinery_login_with :refinery_user

        describe "parcels list" do
          before do
            FactoryGirl.create(:parcel, :from_name => "UniqueTitleOne")
            FactoryGirl.create(:parcel, :from_name => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.parcels_admin_parcels_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          let(:refinery_user) { FactoryGirl.create(:refinery_user) }
          before do
            refinery_user # Creates one record before loading form

            visit refinery.parcels_admin_parcels_path

            click_link "Add New Parcel"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "From", :with => "This is a test of the first string field"
              fill_in "Parcel Date", :with => "2014-01-01"
              fill_in "Courier", :with => "Express Courier"
              fill_in "To", :with => "John Doe"
              select refinery_user.username, :from => "Received by"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Parcels::Parcel.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("From Name can't be blank")
              Refinery::Parcels::Parcel.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:parcel, :from_name => "UniqueTitle") }

            it "should fail" do
              visit refinery.parcels_admin_parcels_path

              click_link "Add New Parcel"

              fill_in "From", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Parcels::Parcel.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:parcel, :from_name => "A from_name") }

          it "should succeed" do
            visit refinery.parcels_admin_parcels_path

            within ".actions" do
              click_link "Edit this parcel"
            end

            fill_in "From", :with => "A different from_name"
            click_button "Save"

            page.should have_content("'A different from_name' was successfully updated.")
            page.should have_no_content("A from_name")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:parcel, :from_name => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.parcels_admin_parcels_path

            click_link "Remove this parcel forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Parcels::Parcel.count.should == 0
          end
        end

      end
    end
  end
end
