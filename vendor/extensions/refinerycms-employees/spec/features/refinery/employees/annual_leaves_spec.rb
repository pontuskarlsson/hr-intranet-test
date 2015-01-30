# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Employees" do
    describe "annual_leaves" do
      refinery_login_with :refinery_user
      let(:employee) { FactoryGirl.create(:employee, user: logged_in_user) }

      describe "list of annual leaves" do
        before do
          FactoryGirl.create(:annual_leave, employee: employee, start_date: '2014-10-09')
          FactoryGirl.create(:annual_leave, employee: employee, start_date: '2014-10-16')
        end

        it "shows two items" do
          visit refinery.employees_annual_leaves_path
          page.should have_content("2014-10-09")
          page.should have_content("2014-10-16")
        end
      end

      describe "registering annual leave" do
        let(:country) { ::Refinery::Employees::Countries::COUNTRIES.first }

        before(:each) do
          FactoryGirl.create(:employment_contract, employee: employee, start_date: '2013-01-01', country: country)
        end

        context 'when it is half-day public holiday' do
          before(:each) do
            FactoryGirl.create(:public_holiday, country: country, holiday_date: '2014-12-24', half_day: true, title: 'Christmas Eve')
          end

          it 'counts the AL as half a day' do
            visit refinery.employees_annual_leaves_path

            fill_in "Start Date", with: "2014-12-24"
            click_button "Save"

            page.should have_content("2014-12-24")
            expect( employee.annual_leaves.last.number_of_days ).to eq 0.5
          end
        end
      end

      describe "removing annual leave" do
        context "when it belongs to the logged in user" do
          let(:annual_leave) { FactoryGirl.create(:annual_leave, employee: employee) }
          it "should succeed" do
            expect( annual_leave.employee.user ).to eq logged_in_user

            visit refinery.employees_annual_leaves_path

            page.should have_content(annual_leave.start_date)
            click_link "Remove"

            page.should_not have_content(annual_leave.start_date)
            Refinery::Employees::AnnualLeave.count.should eq 0
          end
        end
      end

    end
  end
end
