require 'spec_helper'

module Refinery
  module Employees
    describe XeroTrackingCategory do
      describe 'validations' do
        let(:xero_tracking_category) { FactoryGirl.build(:xero_tracking_category) }
        subject { xero_tracking_category }

        it { is_expected.to be_valid }

        context 'when guid is missing' do
          before { xero_tracking_category.guid = '' }
          it { is_expected.not_to be_valid }
        end

        context 'when name is missing' do
          before { xero_tracking_category.name = '' }
          it { is_expected.not_to be_valid }
        end

        context 'when status is included in the list of statuses' do
          before { xero_tracking_category.status = 'not-listed' }
          it { is_expected.not_to be_valid }
        end

        context 'when there is two other Active categories' do
          before { FactoryGirl.create_list(:xero_tracking_category, 2, status: XeroTrackingCategory::STATUS_ACTIVE) }
          before { xero_tracking_category.status = XeroTrackingCategory::STATUS_ACTIVE }
          it { is_expected.not_to be_valid }
        end

        context 'when two options have the same guid' do
          before { xero_tracking_category.options[0][:guid] = xero_tracking_category.options[1][:guid] }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
