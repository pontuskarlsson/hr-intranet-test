# encoding: utf-8
require 'spec_helper'

describe Refinery do
  describe 'Parcels' do
    describe 'shipments' do
      refinery_login_with_devise :authentication_devise_user

      describe 'list of shipments' do
        before do
          FactoryGirl.create(:shipment, to_address: FactoryGirl.create(:shipment_address, name: 'Leon'))
          FactoryGirl.create(:shipment, to_address: FactoryGirl.create(:shipment_address, name: 'Mike'))
        end

        it 'shows two items' do
          visit refinery.parcels_shipments_path
          page.should have_content('Leon')
          page.should have_content('Mike')
        end
      end

      describe 'registering shipments' do
        context 'when there is an existing contact for both to and from addresses' do
          before(:each) do
            FactoryGirl.create(:contact, name: 'Lisa')
            FactoryGirl.create(:contact, name: 'Ted')
          end
          it 'can add shipment' do
            visit refinery.parcels_shipments_path

            fill_in 'From', with: 'Lisa'
            fill_in 'Address To', with: 'Ted'
            select Refinery::Parcels::Shipment::BILL_TO.first, from: 'Bill To'
            click_button 'Add'

            page.should have_content('Lisa')
            page.should have_content('Ted')
            expect( Refinery::Parcels::Shipment.count ).to eq 1
          end

        end
      end

      describe 'showing a Shipment' do
        context 'when the Shipment is manually shipped and have tracking_info' do
          before(:each) do
            FactoryGirl.create(:shipment, status: 'manually_shipped', tracking_number: '123456789', tracking_info: [{ 'date' => DateTime.yesterday, 'message' => 'It was in transit here.' }])

            it 'show the details of the Shipment' do
              visit refinery.parcels_shipment_path(Refinery::Parcels::Shipment.first)

              page.should have_content 'It was in transit here.'
            end
          end
        end
      end

      describe 'updating addresses of Shipment' do
        context 'when entering new address information' do
          before(:each) do
            FactoryGirl.create(:shipment)
          end
          it 'can update Shipment addresses' do
            visit refinery.parcels_shipment_path(Refinery::Parcels::Shipment.first)

            click_link 'Edit Details'

            fill_in 'shipment_address_updater[from_address_name]',    with: 'Ken'
            fill_in 'shipment_address_updater[from_address_street1]', with: '1 First Road'
            fill_in 'shipment_address_updater[from_address_street2]', with: 'Flat A'
            fill_in 'shipment_address_updater[from_address_city]',    with: 'First City'
            fill_in 'shipment_address_updater[from_address_zip]',     with: '11111'
            fill_in 'shipment_address_updater[from_address_state]',   with: 'First State'
            fill_in 'shipment_address_updater[from_address_country]', with: 'First Country'
            fill_in 'shipment_address_updater[from_address_phone]',   with: '555-First'
            fill_in 'shipment_address_updater[from_address_email]',   with: 'first@email.com'

            fill_in 'shipment_address_updater[to_address_name]',      with: 'Barbie'
            fill_in 'shipment_address_updater[to_address_street1]',   with: '1 Second Road'
            fill_in 'shipment_address_updater[to_address_street2]',   with: 'Flat B'
            fill_in 'shipment_address_updater[to_address_city]',      with: 'Second City'
            fill_in 'shipment_address_updater[to_address_zip]',       with: '22222'
            fill_in 'shipment_address_updater[to_address_state]',     with: 'Second State'
            fill_in 'shipment_address_updater[to_address_country]',   with: 'Second Country'
            fill_in 'shipment_address_updater[to_address_phone]',     with: '555-Second'
            fill_in 'shipment_address_updater[to_address_email]',     with: 'second@email.com'
            
            click_button 'Save'

            page.should have_content('Ken')
            page.should have_content('1 First Road')
            page.should have_content('Flat A')
            page.should have_content('First City')
            page.should have_content('11111')
            page.should have_content('First State')
            page.should have_content('First Country')
            page.should have_content('555-First')
            page.should have_content('first@email.com')

            page.should have_content('Barbie')
            page.should have_content('1 Second Road')
            page.should have_content('Flat B')
            page.should have_content('Second City')
            page.should have_content('22222')
            page.should have_content('Second State')
            page.should have_content('Second Country')
            page.should have_content('555-Second')
            page.should have_content('second@email.com')
          end

        end
      end

      describe 'shipping a Shipment' do
        context 'when shipment has no ShipmentParcels registered' do
          let(:shipment) { FactoryGirl.create(:shipment) }
          before { shipment }

          it 'cannot click button Send Shipment' do
            visit refinery.parcels_shipment_path(shipment)

            expect{ click_button 'Send Shipment' }.to raise Capybara::ElementNotFound
          end
        end

        context 'when shipment has one ShipmentParcel registered' do
          let(:shipment) { FactoryGirl.create(:shipment) }
          before { FactoryGirl.create(:shipment_parcel, shipment: shipment) }

          it 'can click button Send Shipment' do
            visit refinery.parcels_shipment_path(shipment)

            expect{ click_button 'Send Shipment' }.not_to raise Capybara::ElementNotFound
          end
        end
      end

    end
  end
end
