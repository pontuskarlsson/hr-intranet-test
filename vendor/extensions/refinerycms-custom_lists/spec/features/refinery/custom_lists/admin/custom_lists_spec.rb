# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "CustomLists" do
    describe "Admin" do
      describe "custom_lists" do
        refinery_login_with_devise :refinery_user

        describe "custom_lists list" do
          before do
            FactoryGirl.create(:custom_list, :title => "UniqueTitleOne")
            FactoryGirl.create(:custom_list, :title => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.custom_lists_admin_custom_lists_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.custom_lists_admin_custom_lists_path

            click_link "Add New Custom List"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Title", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::CustomLists::CustomList.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Title can't be blank")
              Refinery::CustomLists::CustomList.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:custom_list, :title => "UniqueTitle") }

            it "should fail" do
              visit refinery.custom_lists_admin_custom_lists_path

              click_link "Add New Custom List"

              fill_in "Title", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::CustomLists::CustomList.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:custom_list, :title => "A title") }

          it "should succeed" do
            visit refinery.custom_lists_admin_custom_lists_path

            within ".actions" do
              click_link "Edit this custom list"
            end

            fill_in "Title", :with => "A different title"
            click_button "Save"

            page.should have_content("'A different title' was successfully updated.")
            page.should have_no_content("A title")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:custom_list, :title => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.custom_lists_admin_custom_lists_path

            click_link "Remove this custom list forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::CustomLists::CustomList.count.should == 0
          end
        end

      end
    end
  end
end
