# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Employees" do
    describe "Admin" do
      describe "sick_leaves" do
        refinery_login_with_devise :refinery_user

        describe "sick_leaves list" do
          before do
            FactoryGirl.create(:sick_leave, :start_date => "2014-10-09")
            FactoryGirl.create(:sick_leave, :start_date => "2014-10-02")
          end

          it "shows two items" do
            visit refinery.employees_admin_sick_leaves_path
            page.should have_content("2014-10-09")
            page.should have_content("2014-10-02")
          end
        end

        describe "create" do
          let(:employee) { FactoryGirl.create(:employee) }
          before do
            visit refinery.employees_admin_sick_leaves_path

            click_link "Add New Sick Leave"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Employee name", :with => employee.full_name
              fill_in "Start Date", :with => "2014-10-02"
              click_button "Save"

              page.should have_content("'2014-10-02' was successfully added.")
              Refinery::Employees::SickLeave.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Employee can't be blank")
              Refinery::Employees::SickLeave.count.should == 0
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:sick_leave, :start_date => "2014-10-02") }

          it "should succeed" do
            visit refinery.employees_admin_sick_leaves_path

            within ".actions" do
              click_link "Edit this sick leave"
            end

            fill_in "Start Date", :with => "2014-10-09"
            click_button "Save"

            page.should have_content("'2014-10-09' was successfully updated.")
            page.should have_no_content("2014-10-02")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:sick_leave, :start_date => "2014-10-02") }

          it "should succeed" do
            visit refinery.employees_admin_sick_leaves_path

            click_link "Remove this sick leave forever"

            page.should have_content("'2014-10-02' was successfully removed.")
            Refinery::Employees::SickLeave.count.should == 0
          end
        end

      end
    end
  end
end
