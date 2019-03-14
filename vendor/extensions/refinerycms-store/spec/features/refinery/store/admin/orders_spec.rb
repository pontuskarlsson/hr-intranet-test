# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Store" do
    describe "Admin" do
      describe "orders" do
        refinery_login_with_devise :authentication_devise_user

        describe "orders list" do
          before do
            FactoryGirl.create(:order, :order_number => "UniqueTitleOne")
            FactoryGirl.create(:order, :order_number => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.store_admin_orders_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          let(:retailer) { FactoryGirl.create(:retailer) }
          before do
            retailer
            visit refinery.store_admin_orders_path

            click_link "Add New Order"
          end

          context "valid data" do
            it "should succeed" do
              select retailer.name, :from => "Retailer"
              fill_in "Order Number", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Store::Order.count.should == 1
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:order, :order_number => "UniqueTitle", retailer: retailer) }

            it "should fail" do
              visit refinery.store_admin_orders_path

              click_link "Add New Order"

              select retailer.name, :from => "Retailer"
              fill_in "Order Number", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Store::Order.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:order, :order_number => "A order_number") }

          it "should succeed" do
            visit refinery.store_admin_orders_path

            within ".actions" do
              click_link "Edit this order"
            end

            fill_in "Order Number", :with => "A different order_number"
            click_button "Save"

            page.should have_content("'A different order_number' was successfully updated.")
            page.should have_no_content("A order_number")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:order, :order_number => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.store_admin_orders_path

            click_link "Remove this order forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Store::Order.count.should == 0
          end
        end

      end
    end
  end
end
