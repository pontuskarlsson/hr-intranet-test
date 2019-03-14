# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Parcels" do
    describe "parcels" do
      refinery_login_with_devise :refinery_user

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

      describe "update" do
        context "parcel received by current user" do
          let(:other_user) { FactoryGirl.create(:refinery_user) }
          let(:parcel) { FactoryGirl.create(:parcel, received_by: logged_in_user, assigned_to: other_user) }

          it "should succeed" do
            parcel.received_by.should eq logged_in_user
            parcel.assigned_to.should_not eq logged_in_user

            visit refinery.parcels_parcel_path(parcel)

            page.should_not have_content('Can only be edited by')

            fill_in "Parcel Date", :with => Date.today - 1.year
            click_button "Save"

            expect( parcel.reload.parcel_date ).to eq Date.today - 1.year
          end
        end

        context "parcel received by current user" do
          let(:parcel) { FactoryGirl.create(:parcel, assigned_to: logged_in_user) }

          it "should succeed" do
            parcel.received_by.should_not eq logged_in_user
            parcel.assigned_to.should eq logged_in_user

            visit refinery.parcels_parcel_path(parcel)

            page.should_not have_content('Can only be edited by')

            fill_in "Parcel Date", :with => Date.today - 1.year
            click_button "Save"

            expect( parcel.reload.parcel_date ).to eq Date.today - 1.year
          end
        end

        context "not received by not assigned to current user" do
          let(:parcel) { FactoryGirl.create(:parcel) }

          it "should not succeed" do
            parcel.received_by.should_not eq logged_in_user
            parcel.assigned_to.should_not eq logged_in_user

            visit refinery.parcels_parcel_path(parcel)

            page.should have_content('Can only be edited by')

            expect { fill_in "Parcel Date", :with => Date.today - 1.year }.to raise_error
          end
        end
      end

    end
  end
end
