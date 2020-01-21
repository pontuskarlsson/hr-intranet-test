require 'spec_helper'

module Refinery
  module Employees
    describe XeroLineItem do
      describe 'validations' do
        let(:xero_line_item) { FactoryBot.build(:xero_line_item) }
        subject { xero_line_item }

        it { is_expected.to be_valid }

        context 'when xero_account is missing' do
          before { xero_line_item.xero_account = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when description is missing' do
          before { xero_line_item.description = '' }
          it { is_expected.not_to be_valid }
        end

        context 'when quantity is 0 or less' do
          before { xero_line_item.quantity = 0 }
          it { is_expected.not_to be_valid }
        end

        context 'when unit_amount is 0 or less' do
          before { xero_line_item.unit_amount = 0 }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
