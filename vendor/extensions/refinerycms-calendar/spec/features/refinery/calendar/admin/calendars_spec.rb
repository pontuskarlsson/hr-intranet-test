# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Calendar" do
    describe "Admin" do
      describe "calendars" do
        refinery_login_with :refinery_user

        describe "calendars list" do
          before(:each) do
            FactoryGirl.create(:calendar, :title => "UniqueTitleOne")
            FactoryGirl.create(:calendar, :title => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.calendar_admin_calendars_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before(:each) do
            visit refinery.calendar_admin_calendars_path

            click_link "Add New Calendar"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Title", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Calendar::Calendar.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Title can't be blank")
              Refinery::Calendar::Calendar.count.should == 0
            end
          end

          context "duplicate" do
            before(:each) { FactoryGirl.create(:calendar, :title => "UniqueTitle") }

            it "should fail" do
              visit refinery.calendar_admin_calendars_path

              click_link "Add New Calendar"

              fill_in "Title", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Calendar::Calendar.count.should == 1
            end
          end

        end

        describe "edit" do
          before(:each) { FactoryGirl.create(:calendar, :title => "A title") }

          it "should succeed" do
            visit refinery.calendar_admin_calendars_path

            within ".actions" do
              click_link "Edit this calendar"
            end

            fill_in "Title", :with => "A different title"
            click_button "Save"

            page.should have_content("'A different title' was successfully updated.")
            page.should have_no_content("A title")
          end
        end

        describe "destroy" do
          before(:each) { FactoryGirl.create(:calendar, :title => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.calendar_admin_calendars_path

            click_link "Remove this calendar forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Calendar::Calendar.count.should == 0
          end
        end

      end
    end
  end
end
