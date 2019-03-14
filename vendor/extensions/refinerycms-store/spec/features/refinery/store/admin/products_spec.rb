# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Store" do
    describe "Admin" do
      describe "products" do
        refinery_login_with_devise :refinery_user

        describe "products list" do
          before do
            FactoryGirl.create(:product, :product_number => "UniqueTitleOne")
            FactoryGirl.create(:product, :product_number => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.store_admin_products_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          let(:retailer) { FactoryGirl.create(:retailer) }
          before do
            retailer
            visit refinery.store_admin_products_path

            click_link "Add New Product"
          end

          context "valid data" do
            it "should succeed" do
              select retailer.name, :from => "Retailer"
              fill_in "Product Number", :with => "This is a test of the first string field"
              fill_in "Name", with: 'Product Name'
              fill_in "Measurement Unit", with: 'pcs'
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Store::Product.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Product Number can't be blank")
              Refinery::Store::Product.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:product, :product_number => "UniqueTitle") }

            it "should fail" do
              visit refinery.store_admin_products_path

              click_link "Add New Product"

              fill_in "Product Number", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Store::Product.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:product, :product_number => "A product number") }

          it "should succeed" do
            visit refinery.store_admin_products_path

            within ".actions" do
              click_link "Edit this product"
            end

            fill_in "Product Number", :with => "A different product number"
            click_button "Save"

            page.should have_content("'A different product number' was successfully updated.")
            page.should have_no_content("A product number")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:product, :product_number => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.store_admin_products_path

            click_link "Remove this product forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Store::Product.count.should == 0
          end
        end

      end
    end
  end
end
