require 'spec_helper'

module Refinery
  module Shipping
    describe Shipment do
      describe 'validations' do
        let(:shipment) { FactoryGirl.build(:shipment) }
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
          before { FactoryGirl.create(:shipment, from_address: shipment.from_address) }
          it { is_expected.not_to be_valid }
        end

        context 'when :to_address is already used' do
          before { FactoryGirl.create(:shipment, to_address: shipment.to_address) }
          it { is_expected.not_to be_valid }
        end

        context 'when :bill_to is not in list' do
          before { shipment.bill_to = 'Unknown' }
          it { is_expected.not_to be_valid }
        end

        context 'when :status is not in list' do
          before { shipment.status = 'not_valid_status' }
          it { is_expected.not_to be_valid }
        end
      end

      describe '#before_validation' do
        context 'when :created_by is present and :assigned_to is missing' do
          let(:shipment) { FactoryGirl.build(:shipment, assigned_to: nil) }
          it { expect{ shipment.valid? }.to change{ shipment.assigned_to }.from(nil).to(shipment.created_by) }
        end
      end

      describe '#shippable?' do
        subject { shipment.shippable? }

        context 'when :status is equal to not_shipped and :shipment_parcels are present' do
          let(:shipment) { FactoryGirl.create(:shipment, status: 'not_shipped') }
          before { FactoryGirl.create(:shipment_parcel, shipment: shipment) }
          it { is_expected.to eq true }
        end

        context 'when :status is not equal to not_shipped but :shipment_parcels are present' do
          let(:shipment) { FactoryGirl.create(:shipment, status: 'pre_transit') }
          before { FactoryGirl.create(:shipment_parcel, shipment: shipment) }
          it { is_expected.to eq false }
        end

        context 'when :status is equal to not_shipped but no :shipment_parcels are present' do
          let(:shipment) { FactoryGirl.create(:shipment, status: 'not_shipped') }
          it { is_expected.to eq false }
        end
      end
    end
  end
end
