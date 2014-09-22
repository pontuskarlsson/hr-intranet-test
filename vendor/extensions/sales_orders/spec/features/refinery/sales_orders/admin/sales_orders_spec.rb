# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "SalesOrders" do
    describe "Admin" do
      describe "sales_orders" do
        refinery_login_with :refinery_user

        describe "sales_orders list" do
          before do
            FactoryGirl.create(:sales_order, :order_id => "UniqueTitleOne")
            FactoryGirl.create(:sales_order, :order_id => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.sales_orders_admin_sales_orders_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.sales_orders_admin_sales_orders_path

            click_link "Add New Sales Order"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Po Number", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::SalesOrders::SalesOrder.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Po Number can't be blank")
              Refinery::SalesOrders::SalesOrder.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:sales_order, :order_id => "UniqueTitle") }

            it "should fail" do
              visit refinery.sales_orders_admin_sales_orders_path

              click_link "Add New Sales Order"

              fill_in "Po Number", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::SalesOrders::SalesOrder.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:sales_order, :order_id => "A order_id") }

          it "should succeed" do
            visit refinery.sales_orders_admin_sales_orders_path

            within ".actions" do
              click_link "Edit this sales order"
            end

            fill_in "Po Number", :with => "A different order_id"
            click_button "Save"

            page.should have_content("'A different order_id' was successfully updated.")
            page.should have_no_content("A order_id")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:sales_order, :order_id => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.sales_orders_admin_sales_orders_path

            click_link "Remove this sales order forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::SalesOrders::SalesOrder.count.should == 0
          end
        end

      end
    end
  end
end
