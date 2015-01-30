require 'spec_helper'

module Refinery
  module Employees
    describe AnnualLeave do
      describe "validations" do
        let(:annual_leave) { FactoryGirl.build(:annual_leave) }

        it 'validates employee presence' do
          expect(annual_leave).to be_valid

          annual_leave.employee = nil
          expect(annual_leave).not_to be_valid
        end
        it 'validates start_date presence' do
          expect(annual_leave).to be_valid

          annual_leave.start_date = nil
          expect(annual_leave).not_to be_valid
        end
      end
    end
  end
end
