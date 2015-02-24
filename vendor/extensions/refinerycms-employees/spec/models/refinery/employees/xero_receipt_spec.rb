require 'spec_helper'

module Refinery
  module Employees
    describe XeroReceipt do
      describe 'validations' do
        let(:xero_receipt) { FactoryGirl.build(:xero_receipt) }
        subject { xero_receipt }

        it { is_expected.to be_valid }

        context 'when xero_expense_claim is missing' do
          before { xero_receipt.xero_expense_claim = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when xero_contact is missing' do
          before { xero_receipt.xero_contact = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when employee is missing' do
          before { xero_receipt.employee = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when status is included in the list of statuses' do
          before { xero_receipt.status = 'not-listed' }
          it { is_expected.not_to be_valid }
        end

        context 'when total is less than 0' do
          before { xero_receipt.total = -1 }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
