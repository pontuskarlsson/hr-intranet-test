require 'spec_helper'

module Refinery
  module Shipping
    describe ShipmentAddress do
      describe 'validations' do
        let(:shipment_address) { FactoryGirl.build(:shipment_address) }
        subject { shipment_address }

        it { is_expected.to be_valid }

        context 'when :name is missing' do
          before { shipment_address.name = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :easy_post_id is already present' do
          let(:shipment_address) { FactoryGirl.build(:shipment_address, easy_post_id: 'address_1234567') }
          before { FactoryGirl.create(:shipment_address, easy_post_id: shipment_address.easy_post_id) }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
