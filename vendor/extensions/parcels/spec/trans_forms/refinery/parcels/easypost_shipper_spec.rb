require 'spec_helper'

module Refinery
  module Parcels
    describe EasypostShipper do
      before(:each) do
        allow(EasyPost::Order).to receive(:create) { |attributes| OrderMock.new(attributes) }
        allow(EasyPost::Address).to receive(:create) { |attributes| AddressMock.new(attributes) }
      end

      let(:shipment) { FactoryGirl.create(:shipment) }
      let(:attr) { {} }
      let(:form) { EasypostShipper.new({ shipment: shipment }.reverse_merge(attr)) }
      subject { form }
      before { form }

      describe 'validations' do
        it { is_expected.to be_valid }

        context 'when :shipment is missing' do
          before { form.shipment = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :shipment is already shipped' do
          before { shipment.status = 'pre_transit' }
          it { is_expected.not_to be_valid }
        end

        describe 'when :rate_id is present' do
          let(:shipment) { FactoryGirl.create(:shipment_with_rates) }

          context 'when :rate_id is a valid rate' do
            before { form.rate_id = shipment.rates_content[0][:id] }
            it { is_expected.to be_valid }
          end

          context 'when :rate_id is not a valid rate' do
            before { form.rate_id = 'rate_869296843' }
            it { is_expected.not_to be_valid }
          end
        end
      end

      describe '#save' do
        context 'when :bill_to is Sender and choosing courier' do
          let(:shipment) { FactoryGirl.create(:shipment, bill_to: 'Sender') }
          let(:attr) { { courier: ::Refinery::Parcels::Shipment::COURIER_DHL } }

          it { expect( form.save ).to eq true }

          it 'sets the courier of the shipment' do
            expect{ form.save }.to change{ shipment.courier }.from(nil).to(attr[:courier])
          end
        end

        context 'when :bill_to is Receiver and chosen account belongs to :shipments to_contact' do
          let(:shipment) { FactoryGirl.create(:shipment, bill_to: 'Receiver', to_contact: FactoryGirl.create(:contact)) }
          let(:shipment_account) { FactoryGirl.create(:shipment_account, contact: shipment.to_contact) }
          let(:attr) { { bill_to_account_id: shipment_account.id } }

          it { expect( form.save ).to eq true }

          it 'sets the shipment_account of the shipment' do
            expect{ form.save }.to change{ shipment.reload.bill_to_account }.from(nil).to(shipment_account)
          end

          it 'sets the courier of the shipment' do
            expect{ form.save }.to change{ shipment.courier }.from(nil).to(shipment_account.courier)
          end
        end

        context 'when :bill_to is Receiver and chosen account does not belongs to :shipments to_contact' do
          let(:shipment) { FactoryGirl.create(:shipment, bill_to: 'Receiver', to_contact: FactoryGirl.create(:contact)) }
          let(:shipment_account) { FactoryGirl.create(:shipment_account) }
          let(:attr) { { bill_to_account_id: shipment_account.id } }

          it { expect( form.save ).to eq false }

          it 'does not set the shipment_account of the shipment' do
            expect{ form.save }.not_to change{ shipment.bill_to_account }.from(nil)
          end

          it 'does not set the courier of the shipment' do
            expect{ form.save }.not_to change{ shipment.courier }.from(nil)
          end
        end

        context 'when adding courier specific details to ShipmentParcels' do
          let(:shipment) { FactoryGirl.create(:shipment, bill_to: 'Sender') }
          let(:shipment_parcel) { FactoryGirl.create(:shipment_parcel, shipment: shipment) }
          let(:attr) { { courier: ::Refinery::Parcels::Shipment::COURIER_DHL, shipment_parcels_attributes: {
              '0' => { id: shipment_parcel.id, predefined_package: 'JumboParcel', weight: '1' }
          } } }

          it { expect( form.save ).to eq true }

          it 'saves the package type' do
            expect{ form.save }.to change{ shipment_parcel.reload.predefined_package }.from(nil).to('JumboParcel')
          end

          it 'saves the weight' do
            expect{ form.save }.to change{ shipment_parcel.reload.weight }.from(nil).to(1)
          end

          it 'makes the parcel ready to ship' do
            expect{ form.save }.to change{ shipment_parcel.reload.valid_for_easypost? }.from(false).to(true)
          end
        end
      end

      describe '#parcel_hash_for' do
        before(:all) { EasypostShipper.class_eval { public :parcel_hash_for } }
        after(:all)  { EasypostShipper.class_eval { private :parcel_hash_for } }

        let(:shipment_parcel) { FactoryGirl.create(:shipment_parcel, weight: 3.5, length: 12, height: 5.5, width: 10) }
        let(:form) { EasypostShipper.new }

        it 'converts the weight from Kg to oz' do
          expect( form.parcel_hash_for(shipment_parcel)[:weight] ).to eq (shipment_parcel.weight * 35.274).round(1)
        end

        it 'converts the width, length and height from cm to in' do
          expect( form.parcel_hash_for(shipment_parcel)[:width] ).to eq (shipment_parcel.width * 0.393701).round(1)
          expect( form.parcel_hash_for(shipment_parcel)[:height] ).to eq (shipment_parcel.height * 0.393701).round(1)
          expect( form.parcel_hash_for(shipment_parcel)[:length] ).to eq (shipment_parcel.length * 0.393701).round(1)
        end
      end
    end

    describe '#customs_hash_for' do
      before(:all) { EasypostShipper.class_eval { public :customs_hash_for } }
      after(:all)  { EasypostShipper.class_eval { private :customs_hash_for } }

      let(:shipment_parcel) { FactoryGirl.create(:shipment_parcel, weight: 3.5, length: 12, height: 5.5, width: 10) }
      let(:form) { EasypostShipper.new }

      it 'converts the weight from Kg to oz' do
        expect( form.customs_hash_for(shipment_parcel)[:customs_items][0][:weight] ).to eq (shipment_parcel.weight * 35.274).round(1)
      end
    end

  end
end
