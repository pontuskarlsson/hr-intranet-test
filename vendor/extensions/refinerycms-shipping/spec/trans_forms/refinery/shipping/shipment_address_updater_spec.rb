require 'spec_helper'

module Refinery
  module Shipping
    describe ShipmentAddressUpdater do
      let(:shipment) { FactoryBot.create(:shipment) }
      let(:attr) { {} }
      let(:shipment_address_updater) { ShipmentAddressUpdater.new({ shipment: shipment }.reverse_merge(attr)) }
      subject { shipment_address_updater }

      describe 'validations' do
        it { is_expected.to be_valid }

        context 'when shipment is missing' do
          before { shipment_address_updater.shipment = nil }
          it { is_expected.not_to be_valid }
        end

      end

      describe '#save' do
        before { shipment_address_updater.save }
        before { shipment.reload }

        context 'when from address attributes are changed' do
          let(:attr) { { from_address_name: 'Tarzan', from_address_street1: 'Jungle Road 1', from_address_city: 'Jungle', from_address_zip: '12346', from_address_state: 'Stating', from_address_country: 'Junglestan', from_address_phone: '555-Jungle', from_address_email: 'tarzan@jungle.com' } }
          it { is_expected.to be_valid }

          it {
            expect(shipment.from_address.name).to     eq(attr[:from_address_name])
            expect(shipment.from_address.street1).to  eq(attr[:from_address_street1])
            expect(shipment.from_address.city).to     eq(attr[:from_address_city])
            expect(shipment.from_address.zip).to      eq(attr[:from_address_zip])
            expect(shipment.from_address.state).to    eq(attr[:from_address_state])
            expect(shipment.from_address.country).to  eq(attr[:from_address_country])
            expect(shipment.from_address.phone).to    eq(attr[:from_address_phone])
            expect(shipment.from_address.email).to    eq(attr[:from_address_email])
          }
        end
      end
    end

  end
end
