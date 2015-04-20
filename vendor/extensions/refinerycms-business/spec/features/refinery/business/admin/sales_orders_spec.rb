# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Business" do
    describe "Admin" do
      describe "sales_orders" do
        refinery_login_with :refinery_user

        describe "sales_orders list" do
          before do
            FactoryGirl.create(:sales_order, :order_ref => "UniqueTitleOne")
            FactoryGirl.create(:sales_order, :order_ref => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.business_admin_sales_orders_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.business_admin_sales_orders_path

            click_link "Add New Sales Order"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Order Ref", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Business::SalesOrder.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Order Ref can't be blank")
              Refinery::Business::SalesOrder.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:sales_order, :order_ref => "UniqueTitle") }

            it "should fail" do
              visit refinery.business_admin_sales_orders_path

              click_link "Add New Sales Order"

              fill_in "Order Ref", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Business::SalesOrder.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:sales_order, :order_ref => "A order_id") }

          it "should succeed" do
            visit refinery.business_admin_sales_orders_path

            within ".actions" do
              click_link "Edit this sales order"
            end

            fill_in "Order Ref", :with => "A different order_id"
            click_button "Save"

            page.should have_content("'A different order_id' was successfully updated.")
            page.should have_no_content("A order_id")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:sales_order, :order_ref => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.business_admin_sales_orders_path

            click_link "Remove this sales order forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Business::SalesOrder.count.should == 0
          end
        end

      end
    end
  end
end
