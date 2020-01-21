require 'spec_helper'

module Refinery
  module Employees
    describe XeroAccount do
      describe 'validations' do
        let(:xero_account) { FactoryBot.build(:xero_account) }
        subject { xero_account }

        it { is_expected.to be_valid }

        context 'when guid is missing' do
          before { xero_account.guid = '' }
          it { is_expected.not_to be_valid }
        end

        context 'when guid is already present' do
          before { FactoryBot.create(:xero_account, guid: xero_account.guid) }
          it { is_expected.not_to be_valid }
        end

        context 'when name is missing' do
          before { xero_account.name = '' }
          it { is_expected.not_to be_valid }
        end

        context 'when code is missing' do
          before { xero_account.code = '' }
          it { is_expected.not_to be_valid }
        end

        context 'when code is already present' do
          before { FactoryBot.create(:xero_account, code: xero_account.code) }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
