# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Employees" do
    describe "Admin" do
      describe "public_holidays" do
        refinery_login

        describe "public_holidays list" do
          before do
            FactoryBot.create(:public_holiday, :title => "New Years Day")
            FactoryBot.create(:public_holiday, :title => "Christmas Day")
          end

          it "shows two items" do
            visit refinery.employees_admin_public_holidays_path
            page.should have_content("New Years Day")
            page.should have_content("Christmas Day")
          end
        end

        describe "create" do
          before do
            visit refinery.employees_admin_public_holidays_path

            click_link "Add New Public Holiday"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Title", :with => "National Day"
              fill_in "Holiday Date", :with => "2014-10-01"
              select ::Refinery::Employees::Countries::COUNTRIES.first, :from => "Country"
              click_button "Save"

              page.should have_content("'National Day' was successfully added.")
              Refinery::Employees::PublicHoliday.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Title can't be blank")
              Refinery::Employees::PublicHoliday.count.should == 0
            end
          end

        end

        describe "edit" do
          before { FactoryBot.create(:public_holiday, :title => "Christmas Day") }

          it "should succeed" do
            visit refinery.employees_admin_public_holidays_path

            within ".actions" do
              click_link "Edit this public holiday"
            end

            fill_in "Title", :with => "New Years Day"
            click_button "Save"

            page.should have_content("'New Years Day' was successfully updated.")
            page.should have_no_content("Christmas Day")
          end
        end

        describe "destroy" do
          before { FactoryBot.create(:public_holiday, :title => "Christmas Day") }

          it "should succeed" do
            visit refinery.employees_admin_public_holidays_path

            click_link "Remove this public holiday forever"

            page.should have_content("'Christmas Day' was successfully removed.")
            Refinery::Employees::PublicHoliday.count.should == 0
          end
        end

      end
    end
  end
end
