require 'spec_helper'

module Refinery
  module Shipping
    describe Address do
      describe 'validations' do
        let(:shipment_address) { FactoryBot.build(:shipment_address) }
        subject { shipment_address }

        it { is_expected.to be_valid }

        context 'when :name is missing' do
          before { shipment_address.name = nil }
          it { pending 'No validations enabled at this time'; is_expected.not_to be_valid }
        end
      end
    end
  end
end
