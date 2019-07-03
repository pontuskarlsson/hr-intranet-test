require 'spec_helper'

module Refinery
  module Shipping
    describe ShipmentParcel do
      describe 'validations' do
        let(:shipment_parcel) { FactoryGirl.build(:shipment_parcel) }
        subject { shipment_parcel }

        it { is_expected.to be_valid }

        context 'when :shipment is missing' do
          before { shipment_parcel.shipment = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :description is missing' do
          before { shipment_parcel.description = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :weight is missing' do
          before { shipment_parcel.weight = nil }
          it { is_expected.to be_valid }
        end

        describe '#valid_for_easypost?' do
          let(:shipment_parcel) { FactoryGirl.build(:shipment_parcel_with_easypost) }
          subject { shipment_parcel.valid_for_easypost? }

          it { is_expected.to eq true }

          context 'when :weight is missing' do
            before { shipment_parcel.weight = nil }
            it { is_expected.to eq false }
          end

          context 'when :length is missing' do
            before { shipment_parcel.length = nil }
            it { is_expected.to eq false }
          end

          context 'when :height is missing' do
            before { shipment_parcel.height = nil }
            it { is_expected.to eq false }
          end

          context 'when :width is missing' do
            before { shipment_parcel.width = nil }
            it { is_expected.to eq false }
          end

          context 'when predefined_package is not in couriers list' do
            before { shipment_parcel.predefined_package = 'UnknownPackage' }
            it { is_expected.to eq false }
          end

          describe 'that has selected a predefined package type' do
            before { shipment_parcel.predefined_package = (Refinery::Shipping::Shipment::COURIERS[shipment_parcel.shipment.try(:courier_company_label)] || {} )[:'refinerycms-shipping'].first }

            it { is_expected.to eq true }

            context 'when :length, :height and :width is missing' do
              before {
                shipment_parcel.length = nil
                shipment_parcel.height = nil
                shipment_parcel.width = nil
              }
              it { is_expected.to eq true }
            end
          end

          describe 'that ships Internationally' do
            let(:shipment_parcel) { FactoryGirl.build(:shipment_parcel_international) }
            subject { shipment_parcel.valid_for_easypost?(true) }

            it { is_expected.to eq true }

            context 'when :contents_type is missing' do
              before { shipment_parcel.contents_type = nil }
              it { is_expected.to eq false }
            end

            context 'when :origin_country is missing' do
              before { shipment_parcel.origin_country = nil }
              it { is_expected.to eq false }
            end

            context 'when :quantity is not greater than 0' do
              before { shipment_parcel.quantity = 0 }
              it { is_expected.to eq false }
            end

            context 'when :value is not greater than 0' do
              before { shipment_parcel.value = 0 }
              it { is_expected.to eq false }
            end
          end
        end
      end
    end
  end
end
