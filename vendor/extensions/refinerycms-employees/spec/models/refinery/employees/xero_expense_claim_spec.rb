require 'spec_helper'

module Refinery
  module Employees
    describe XeroExpenseClaim do
      describe 'validations' do
        let(:xero_expense_claim) { FactoryGirl.build(:xero_expense_claim) }
        subject { xero_expense_claim }

        it { is_expected.to be_valid }

        context 'when employee is missing' do
          before { xero_expense_claim.employee = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when added_by is missing' do
          before { xero_expense_claim.added_by = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when description is missing' do
          before { xero_expense_claim.description = '' }
          it { is_expected.not_to be_valid }
        end

        context 'when status is included in the list of statuses' do
          before { xero_expense_claim.status = 'not-listed' }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
