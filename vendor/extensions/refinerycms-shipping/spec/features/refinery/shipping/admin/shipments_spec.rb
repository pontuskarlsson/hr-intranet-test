# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Shipping" do
    describe "Admin" do
      describe "shipments" do
        refinery_login_with_devise :authentication_devise_user

        describe "shipments list" do
          let(:shipment1) { FactoryBot.create(:shipment) }
          let(:shipment2) { FactoryBot.create(:shipment) }
          before do
            shipment1; shipment2
          end

          it "shows two items" do
            visit refinery.shipping_admin_shipments_path
            page.should have_content(shipment1.to_address_name)
            page.should have_content(shipment2.to_address_name)
          end
        end

        describe "create" do
          let(:contact1) { FactoryBot.create(:contact) }
          let(:contact2) { FactoryBot.create(:contact) }
          let(:user) { FactoryBot.create(:authentication_devise_user) }
          before do
            contact1; contact2; user # Creates records before loading form

            visit refinery.shipping_admin_shipments_path

            click_link "Add New Shipment"
          end

          context "valid data" do
            it "should succeed" do
              select user.username, from: 'Created By'
              fill_in "From Contact", :with => contact1.name
              fill_in "To Contact", :with => contact2.name
              select "Sender", from: "Bill To"
              click_button "Save"

              Refinery::Shipping::Shipment.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryBot.create(:shipment) }

          it "should succeed" do
            visit refinery.shipping_admin_shipments_path

            within ".actions" do
              click_link "Edit this shipment"
            end

            click_button "Save"
          end
        end

        describe "destroy" do
          before { FactoryBot.create(:shipment) }

          it "should succeed" do
            visit refinery.shipping_admin_shipments_path

            click_link "Remove this shipment forever"

            Refinery::Shipping::Shipment.count.should == 0
          end
        end

      end
    end
  end
end
