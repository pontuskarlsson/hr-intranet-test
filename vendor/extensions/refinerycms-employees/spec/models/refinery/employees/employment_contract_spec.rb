require 'spec_helper'

module Refinery
  module Employees
    describe EmploymentContract do
      describe "validations" do
        let(:employment_contract) { FactoryBot.build(:employment_contract) }

        it 'validates employee presence' do
          expect(employment_contract).to be_valid

          employment_contract.employee = nil
          expect(employment_contract).not_to be_valid
        end
        it 'validates start_date presence' do
          expect(employment_contract).to be_valid

          employment_contract.start_date = nil
          expect(employment_contract).not_to be_valid
        end
        it 'validates country inclusion' do
          expect(employment_contract).to be_valid

          employment_contract.country = 'random string'
          expect(employment_contract).not_to be_valid
        end
      end
    end
  end
end
