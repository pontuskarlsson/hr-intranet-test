# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Parcels" do
    describe "Admin" do
      describe "shipments" do
        refinery_login_with_devise :authentication_devise_user

        describe "shipments list" do
          let(:shipment1) { FactoryGirl.create(:shipment) }
          let(:shipment2) { FactoryGirl.create(:shipment) }
          before do
            shipment1; shipment2
          end

          it "shows two items" do
            visit refinery.parcels_admin_shipments_path
            page.should have_content(shipment1.to_address_name)
            page.should have_content(shipment2.to_address_name)
          end
        end

        describe "create" do
          let(:contact1) { FactoryGirl.create(:contact) }
          let(:contact2) { FactoryGirl.create(:contact) }
          let(:user) { FactoryGirl.create(:authentication_devise_user) }
          before do
            contact1; contact2; user # Creates records before loading form

            visit refinery.parcels_admin_shipments_path

            click_link "Add New Shipment"
          end

          context "valid data" do
            it "should succeed" do
              select user.username, from: 'Created By'
              fill_in "From Contact", :with => contact1.name
              fill_in "To Contact", :with => contact2.name
              select "Sender", from: "Bill To"
              click_button "Save"

              Refinery::Parcels::Shipment.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:shipment) }

          it "should succeed" do
            visit refinery.parcels_admin_shipments_path

            within ".actions" do
              click_link "Edit this shipment"
            end

            click_button "Save"
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:shipment) }

          it "should succeed" do
            visit refinery.parcels_admin_shipments_path

            click_link "Remove this shipment forever"

            Refinery::Parcels::Shipment.count.should == 0
          end
        end

      end
    end
  end
end
