# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Employees" do
    describe "sick_leaves" do
      refinery_login_with :refinery_user
      let(:employee) { FactoryGirl.create(:employee, user: logged_in_user) }
      before :each do
        employee
      end

      describe "list of sick leaves" do
        before do
          FactoryGirl.create(:sick_leave, employee: employee, start_date: '2012-01-31')
          FactoryGirl.create(:sick_leave, employee: employee, start_date: '2012-07-31')
        end

        it "shows two items" do
          visit refinery.employees_sick_leaves_path
          page.should have_content("2012-01-31")
          page.should have_content("2012-07-31")
        end
      end

      describe "registering sick leaves" do
        context "when there is no recent sick leave" do

          it "can register sick leave for today" do
            visit refinery.employees_sick_leaves_path
            click_button "I am sick today"

            page.should have_content("You have registered Sick Leave today")
            expect( Refinery::Employees::SickLeave.count ).to eq 1
          end

        end
      end

    end
  end
end
