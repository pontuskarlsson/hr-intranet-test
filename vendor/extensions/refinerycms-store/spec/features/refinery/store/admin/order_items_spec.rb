# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Store" do
    describe "Admin" do
      describe "order_items" do
        refinery_login_with_devise :refinery_user

        describe "order_items list" do
          before do
            FactoryGirl.create(:order_item, :product_number => "UniqueTitleOne")
            FactoryGirl.create(:order_item, :product_number => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.store_admin_order_items_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          let(:order) { FactoryGirl.create(:order) }
          before do
            order
            visit refinery.store_admin_order_items_path

            click_link "Add New Order Item"
          end

          context "valid data" do
            it "should succeed" do
              select order.order_number, :from => "Order"
              fill_in "Product Number", :with => "This is a test of the first string field"
              fill_in "Quantity", :with => "1"
              fill_in "Price per item", :with => "100"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Store::OrderItem.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Product Number can't be blank")
              Refinery::Store::OrderItem.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:order_item, :product_number => "UniqueTitle") }

            it "should fail" do
              visit refinery.store_admin_order_items_path

              click_link "Add New Order Item"

              fill_in "Product Number", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Store::OrderItem.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:order_item, :product_number => "A product number") }

          it "should succeed" do
            visit refinery.store_admin_order_items_path

            within ".actions" do
              click_link "Edit this order item"
            end

            fill_in "Product Number", :with => "A different product number"
            click_button "Save"

            page.should have_content("'A different product number' was successfully updated.")
            page.should have_no_content("A product number")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:order_item, :product_number=> "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.store_admin_order_items_path

            click_link "Remove this order item forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Store::OrderItem.count.should == 0
          end
        end

      end
    end
  end
end
