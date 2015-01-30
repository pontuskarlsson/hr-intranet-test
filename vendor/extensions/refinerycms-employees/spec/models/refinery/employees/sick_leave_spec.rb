require 'spec_helper'

module Refinery
  module Employees
    describe SickLeave do
      describe "validations" do
        let(:sick_leave) { FactoryGirl.build(:sick_leave) }

        it 'validates employee presence' do
          expect(sick_leave).to be_valid

          sick_leave.employee = nil
          expect(sick_leave).not_to be_valid
        end
        it 'validates start_date presence' do
          expect(sick_leave).to be_valid

          sick_leave.start_date = nil
          expect(sick_leave).not_to be_valid
        end
      end
    end
  end
end
