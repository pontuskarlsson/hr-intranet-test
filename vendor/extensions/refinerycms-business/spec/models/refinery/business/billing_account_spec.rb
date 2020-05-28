require 'spec_helper'

module Refinery
  module Business
    describe BillingAccount do
      describe 'validations' do
        let(:billing_account) { FactoryBot.build(:billing_account) }
        subject { billing_account }

        it { is_expected.to be_valid }

        context 'when :company is missing' do
          before { billing_account.company = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :name is missing' do
          before { billing_account.name = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :company already have another billing_account' do
          before { FactoryBot.create(:billing_account, company: billing_account.company) }
          it { is_expected.to be_valid }
        end
      end
    end
  end
end
