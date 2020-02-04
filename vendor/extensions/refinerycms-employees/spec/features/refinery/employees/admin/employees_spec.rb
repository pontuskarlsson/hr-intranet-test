# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Employees" do
    describe "Admin" do
      describe "employees" do
        refinery_login

        describe "employees list" do
          before do
            FactoryBot.create(:employee, :employee_no => "UniqueTitleOne")
            FactoryBot.create(:employee, :employee_no => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.employees_admin_employees_path

            expect(page).to have_content("UniqueTitleOne")
            expect(page).to have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.employees_admin_employees_path

            click_link "Add New Employee"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Employee No", :with => "Employee no 001"
              fill_in "Full Name", :with => "John Doe"
              click_button "Save"

              expect(page).to have_content("'Employee no 001' was successfully added.")
              expect( Refinery::Employees::Employee.count ).to eq 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              expect(page).to have_content("Employee No can't be blank")
              expect( Refinery::Employees::Employee.count ).to eq 0
            end
          end

          context "duplicate" do
            before { FactoryBot.create(:employee, :employee_no => "UniqueTitle") }

            it "should fail" do
              visit refinery.employees_admin_employees_path

              click_link "Add New Employee"

              fill_in "Employee No", :with => "UniqueTitle"
              click_button "Save"

              expect(page).to have_content("There were problems")
              expect( Refinery::Employees::Employee.count ).to eq 1
            end
          end

        end

        describe "edit" do
          before { FactoryBot.create(:employee, :employee_no => "A employee_no") }

          it "should succeed" do
            visit refinery.employees_admin_employees_path

            within ".actions" do
              click_link "Edit this employee"
            end

            fill_in "Employee No", :with => "A different employee_no"
            click_button "Save"

            expect(page).to have_content("'A different employee_no' was successfully updated.")
            expect(page).to have_content("A employee_no")
          end
        end

        describe "destroy" do
          before { FactoryBot.create(:employee, :employee_no => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.employees_admin_employees_path

            click_link "Remove this employee forever"

            expect(page).to have_content("'UniqueTitleOne' was successfully removed.")
            expect( Refinery::Employees::Employee.count ).to eq 0
          end
        end

      end
    end
  end
end
