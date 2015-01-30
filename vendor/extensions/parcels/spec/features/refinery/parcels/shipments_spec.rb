# encoding: utf-8
require 'spec_helper'

describe Refinery do
  describe 'Parcels' do
    describe 'shipments' do
      refinery_login_with :refinery_user

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
            click_button 'Add'

            page.should have_content('You have registered Sick Leave today')
            expect( Refinery::Parcels::Shipment.count ).to eq 1
          end

        end
      end

    end
  end
end
