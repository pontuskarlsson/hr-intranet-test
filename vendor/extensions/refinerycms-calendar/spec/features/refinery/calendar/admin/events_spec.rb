# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Calendar" do
    describe "Admin" do
      describe "events" do
        refinery_login_with_devise :authentication_devise_user

        describe "events list" do
          before(:each) do
            FactoryGirl.create(:event, :title => "UniqueTitleOne")
            FactoryGirl.create(:event, :title => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.calendar_admin_events_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          let(:calendar) { FactoryGirl.create(:calendar) }
          before(:each) do
            calendar
            visit refinery.calendar_admin_events_path

            click_link "Add New Event"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Title", :with => "This is a test of the first string field"
              fill_in "From", :with => "2014-05-09 12:30:00 UTC"
              select calendar.title, from: "Calendar"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Calendar::Event.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Title can't be blank")
              Refinery::Calendar::Event.count.should == 0
            end
          end

        end

        describe "edit" do
          before(:each) { FactoryGirl.create(:event, :title => "A title") }

          it "should succeed" do
            visit refinery.calendar_admin_events_path

            within ".actions" do
              click_link "Edit this event"
            end

            fill_in "Title", :with => "A different title"
            click_button "Save"

            page.should have_content("'A different title' was successfully updated.")
            page.should have_no_content("A title")
          end
        end

        describe "destroy" do
          before(:each) { FactoryGirl.create(:event, :title => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.calendar_admin_events_path

            click_link "Remove this event forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Calendar::Event.count.should == 0
          end
        end

      end
    end
  end
end
