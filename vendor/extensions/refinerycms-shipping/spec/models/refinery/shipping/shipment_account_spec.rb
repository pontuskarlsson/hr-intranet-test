require 'spec_helper'

module Refinery
  module Shipping
    describe ShipmentAccount do
      describe 'validations' do
        let(:shipment_account) { FactoryGirl.build(:shipment_account) }
        subject { shipment_account }

        it { is_expected.to be_valid }

        context 'when :contact is missing' do
          before { shipment_account.contact = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :description is missing' do
          before { shipment_account.description = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :account_no is missing' do
          before { shipment_account.account_no = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :courier is not a valid EasyPost courier' do
          before { shipment_account.courier = ::Refinery::Shipping::Shipment::COURIER_SF }
          it { is_expected.not_to be_valid }
        end

      end
    end
  end
end
