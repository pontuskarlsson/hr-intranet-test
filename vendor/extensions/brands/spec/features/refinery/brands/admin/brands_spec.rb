# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Brands" do
    describe "Admin" do
      describe "brands" do
        refinery_login_with :refinery_user

        describe "brands list" do
          before do
            FactoryGirl.create(:brand, :name => "UniqueTitleOne")
            FactoryGirl.create(:brand, :name => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.brands_admin_brands_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.brands_admin_brands_path

            click_link "Add New Brand"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Name", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Brands::Brand.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Name can't be blank")
              Refinery::Brands::Brand.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:brand, :name => "UniqueTitle") }

            it "should fail" do
              visit refinery.brands_admin_brands_path

              click_link "Add New Brand"

              fill_in "Name", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Brands::Brand.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:brand, :name => "A name") }

          it "should succeed" do
            visit refinery.brands_admin_brands_path

            within ".actions" do
              click_link "Edit this brand"
            end

            fill_in "Name", :with => "A different name"
            click_button "Save"

            page.should have_content("'A different name' was successfully updated.")
            page.should have_no_content("A name")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:brand, :name => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.brands_admin_brands_path

            click_link "Remove this brand forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Brands::Brand.count.should == 0
          end
        end

      end
    end
  end
end
