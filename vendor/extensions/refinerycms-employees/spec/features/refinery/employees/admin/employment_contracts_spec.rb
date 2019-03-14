# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "EmploymentContracts" do
    describe "Admin" do
      describe "employment_contracts" do
        refinery_login_with_devise :authentication_devise_user

        describe "employment_contracts list" do
          before do
            FactoryGirl.create(:employment_contract, start_date: '2013-01-01')
            FactoryGirl.create(:employment_contract, start_date: '2014-01-01')
          end

          it "shows two items" do
            visit refinery.employees_admin_employment_contracts_path
            page.should have_content("2013-01-01")
            page.should have_content("2014-01-01")
          end
        end

        describe "create" do
          let(:employee) { FactoryGirl.create(:employee) }
          before do
            visit refinery.employees_admin_employment_contracts_path

            click_link "Add New Employment Contract"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Employee", :with => employee.full_name
              fill_in "Start Date", :with => "2013-06-01"
              click_button "Save"

              page.should have_content("'2013-06-01' was successfully added.")
              Refinery::Employees::EmploymentContract.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Start Date can't be blank")
              Refinery::Employees::EmploymentContract.count.should == 0
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:employment_contract, :start_date => "2012-01-01") }

          it "should succeed" do
            visit refinery.employees_admin_employment_contracts_path

            within ".actions" do
              click_link "Edit this employment contract"
            end

            fill_in "Start Date", :with => "2011-01-01"
            click_button "Save"

            page.should have_content("'2011-01-01' was successfully updated.")
            page.should have_no_content("2012-01-01")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:employment_contract, start_date: '2012-01-01') }

          it "should succeed" do
            visit refinery.employees_admin_employment_contracts_path

            click_link "Remove this employment contract forever"

            page.should have_content("'2012-01-01' was successfully removed.")
            Refinery::Employees::EmploymentContract.count.should == 0
          end
        end

      end
    end
  end
end
