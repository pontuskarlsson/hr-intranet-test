# encoding: utf-8
require 'spec_helper'

describe Refinery do
  describe 'Shipping' do
    describe 'shipments' do
      refinery_login

      describe 'list of shipments' do
        before do
          FactoryBot.create(:shipment, to_address: FactoryBot.create(:shipment_address, name: 'Leon'))
          FactoryBot.create(:shipment, to_address: FactoryBot.create(:shipment_address, name: 'Mike'))
        end

        it 'shows two items' do
          visit refinery.shipping_shipments_path
          page.should have_content('Leon')
          page.should have_content('Mike')
        end
      end

      describe 'creating a new Shipment' do
        context 'when inputing valid data' do
          let(:shipper) { FactoryBot.create(:shipment, code: '00001', name: 'Shipper Company') }
          let(:receiver) { FactoryBot.create(:shipment, code: '00002', name: 'Receiver Company') }

          it 'adds a new Shipment with the next available Code from the number series' do
            visit refinery.shipping_shipments_path

            click_button 'Add new Shipment'

            fill_in 'Shipper', with: shipper.label
            fill_in 'Receiver', with: receiver.label
            select 'Rail', from: 'Mode'
            click_button 'Add'

            expect( page ).to have_content 'SHIPMENT DETAILS'
            expect( page ).to have_content shipper.label
            expect( page ).to have_content receiver.label

            expect( Refinery::Shipping::Shipment.count ).to eq 1
          end
        end
      end

      describe 'showing a Shipment' do
        context 'for a basic shipment' do
          let(:shipment) { FactoryBot.create(:shipment) }

          it 'show the details of the Shipment' do
            visit refinery.shipping_shipment_path(shipment)

            expect( page ).to have_content shipment.code
          end
        end
      end

    end
  end
end
