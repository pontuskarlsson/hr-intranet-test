require 'spec_helper'

module Refinery
  module Employees
    describe Employee do
      describe "validations" do
        let(:employee) { FactoryGirl.build(:employee) }

        it 'validates employee_no presence' do
          expect(employee).to be_valid

          employee.employee_no = ''
          expect(employee).not_to be_valid
        end
        it 'validates full_name presence' do
          expect(employee).to be_valid

          employee.full_name = ''
          expect(employee).not_to be_valid
        end
        it 'validates employee_no uniqueness' do
          expect(employee).to be_valid

          FactoryGirl.create(:employee, employee_no: employee.employee_no)
          expect(employee).not_to be_valid
        end
      end

      describe '.current scope' do
        let(:active_employee_1) { FactoryGirl.create(:employee) }
        let(:active_employee_2) { FactoryGirl.create(:employee) }
        let(:previous_employee) { FactoryGirl.create(:employee) }
        before :each do
          FactoryGirl.create(:employment_contract, employee: active_employee_1, start_date: Date.today - 1.year, end_date: Date.today + 1.week)
          FactoryGirl.create(:employment_contract, employee: active_employee_2, start_date: Date.today, end_date: nil)
          FactoryGirl.create(:employment_contract, employee: previous_employee, start_date: Date.today - 1.year, end_date: Date.today - 1.month)
        end

        it 'only returns Employees with active employment contracts' do
          employees = Employee.current
          expect( employees ).to include active_employee_1
          expect( employees ).to include active_employee_2
          expect( employees ).not_to include previous_employee
        end
      end
    end
  end
end
