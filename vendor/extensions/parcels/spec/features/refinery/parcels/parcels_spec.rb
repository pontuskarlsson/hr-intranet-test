# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Parcels" do
    describe "parcels" do
      refinery_login_with :refinery_user

      describe "parcels list" do
        before do
          FactoryGirl.create(:parcel, :courier => "UniqueTitleOne")
          FactoryGirl.create(:parcel, :courier => "UniqueTitleTwo")
        end

        it "shows two items" do
          visit refinery.parcels_parcels_path
          page.should have_content("UniqueTitleOne")
          page.should have_content("UniqueTitleTwo")
        end
      end

      describe "create" do
        before do
          visit refinery.parcels_parcels_path
        end

        context "valid data" do
          it "should succeed" do
            fill_in "From", :with => "This is a test of the first string field"
            fill_in "Courier", :with => "Express Shipments"
            fill_in "Air Waybill No", :with => "987654321"
            fill_in "Addressed To", :with => "Bruce Wayne"
            click_button "Save"

            page.should have_content("This is a test of the first string field")
            Refinery::Parcels::Parcel.count.should == 1
          end
        end

        context "invalid data" do
          it "should fail" do
            click_button "Save"

            #page.should have_content("From can't be blank")
            Refinery::Parcels::Parcel.count.should == 0
          end
        end

      end

    end
  end
end
