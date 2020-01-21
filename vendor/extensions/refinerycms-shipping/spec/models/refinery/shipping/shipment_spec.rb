require 'spec_helper'

module Refinery
  module Shipping
    describe Shipment do
      describe 'validations' do
        let(:shipment) { FactoryBot.build(:shipment) }
        subject { shipment }

        it { is_expected.to be_valid }

        context 'when :created_by is missing' do
          before { shipment.created_by = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :courier is not in list' do
          before { shipment.courier_company_label = 'InvalidCourier' }
          it { is_expected.to be_valid }
        end

        context 'when :from_address is already used' do
          before { FactoryBot.create(:shipment, from_address: shipment.from_address) }
          it { is_expected.not_to be_valid }
        end

        context 'when :to_address is already used' do
          before { FactoryBot.create(:shipment, to_address: shipment.to_address) }
          it { is_expected.not_to be_valid }
        end

        context 'when :bill_to is not in list' do
          before { shipment.bill_to = 'Unknown' }
          it { pending 'Bill To validations not enabled at this time'; is_expected.not_to be_valid }
        end

        context 'when :status is not in list' do
          before { shipment.status = 'not_valid_status' }
          it { pending 'Status validations not enabled at this time'; is_expected.not_to be_valid }
        end
      end

      describe '#shippable?' do
        subject { shipment.shippable? }

        context 'when :status is equal to not_shipped and :shipment_parcels are present' do
          let(:shipment) { FactoryBot.create(:shipment, status: 'not_shipped') }
          before { FactoryBot.create(:shipment_parcel, shipment: shipment) }
          it { is_expected.to eq true }
        end

        context 'when :status is not equal to not_shipped but :shipment_parcels are present' do
          let(:shipment) { FactoryBot.create(:shipment, status: 'pre_transit') }
          before { FactoryBot.create(:shipment_parcel, shipment: shipment) }
          it { is_expected.to eq false }
        end

        context 'when :status is equal to not_shipped but no :shipment_parcels are present' do
          let(:shipment) { FactoryBot.create(:shipment, status: 'not_shipped') }
          it { is_expected.to eq false }
        end
      end
    end
  end
end
