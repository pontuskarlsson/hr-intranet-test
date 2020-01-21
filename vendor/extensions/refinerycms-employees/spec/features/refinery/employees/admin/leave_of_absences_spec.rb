# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Employees" do
    describe "Admin" do
      describe "leave_of_absences" do
        refinery_login_with_devise :authentication_devise_user

        describe "annual_leaves list" do
          before do
            FactoryBot.create(:leave_of_abesence, :start_date => "2014-10-09")
            FactoryBot.create(:leave_of_abesence, :start_date => "2014-10-02")
          end

          it "shows two items" do
            visit refinery.employees_admin_leave_of_abesences_path
            page.should have_content("2014-10-09")
            page.should have_content("2014-10-02")
          end
        end

        describe "create" do
          let(:employee) { FactoryBot.create(:employee) }
          before do
            visit refinery.employees_admin_leave_of_abesences_path

            click_link "Add New Leave Of Absence"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Employee name", :with => employee.full_name
              fill_in "Start Date", :with => "2014-10-02"
              click_button "Save"

              page.should have_content("'2014-10-02' was successfully added.")
              Refinery::Employees::LeaveOfAbsence.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Employee can't be blank")
              Refinery::Employees::LeaveOfAbsence.count.should == 0
            end
          end

        end

        describe "edit" do
          before { FactoryBot.create(:leave_of_abesence, :start_date => "2014-10-02") }

          it "should succeed" do
            visit refinery.employees_admin_leave_of_abesences_path

            within ".actions" do
              click_link "Edit this leave of absence"
            end

            fill_in "Start Date", :with => "2014-10-09"
            click_button "Save"

            page.should have_content("'2014-10-09' was successfully updated.")
            page.should have_no_content("2014-10-02")
          end
        end

        describe "destroy" do
          before { FactoryBot.create(:leave_of_abesence, :start_date => "2014-10-02") }

          it "should succeed" do
            visit refinery.employees_admin_leave_of_abesences_path

            click_link "Remove this leave of absence forever"

            page.should have_content("'2014-10-02' was successfully removed.")
            Refinery::Employees::LeaveOfAbsence.count.should == 0
          end
        end

      end
    end
  end
end
