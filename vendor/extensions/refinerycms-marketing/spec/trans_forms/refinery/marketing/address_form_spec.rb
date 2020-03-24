require 'spec_helper'

module Refinery
  module Marketing
    describe AddressForm do
      let!(:contact) { FactoryBot.create(:contact) }
      let(:attr) { { relation: 'mail' } }
      let(:form) { AddressForm.new_in_model(contact, attr) }
      subject { form }

      describe 'validations' do
        it { is_expected.to be_valid }

        context 'when :relation is missing' do
          let(:attr) { { relation: '' } }

          it { is_expected.not_to be_valid }
        end

      end

      describe '#save' do
        subject { form.save }

        context 'when the contact does not have an existing address and at least :country_code is supplied' do
          let(:attr) { { country: 'Sweden', relation: 'mail' } }

          it { is_expected.to eq true }

          it 'creates a new linked address' do
            expect{
              form.save
            }.to change{ contact.addresses.count }.by(1)
          end
        end

        context 'when the contact have an existing address for the relation and at least :country_code is supplied' do
          let!(:address) { FactoryBot.create(:address, country: 'Norway') }
          let!(:link) { FactoryBot.create(:link, contact: contact, linked: address, relation: 'mail') }
          let(:attr) { { country: 'Sweden', relation: 'mail' } }

          it { is_expected.to eq true }

          it 'does not create a new linked address' do
            expect{
              form.save
            }.not_to change{ contact.addresses.count }.from(1)
          end

          it 'updates the existing address' do
            expect{
              form.save
            }.to change{ address.reload.country }.from('Norway').to 'Sweden'
          end
        end

        context 'when the contact have an existing address but for another relation and at least :country_code is supplied' do
          let!(:address) { FactoryBot.create(:address, country: 'Norway') }
          let!(:link) { FactoryBot.create(:link, contact: contact, linked: address, relation: 'mail') }
          let(:attr) { { country: 'Sweden', relation: 'other' } }

          it { is_expected.to eq true }

          it 'creates a new linked address' do
            expect{
              form.save
            }.to change{ contact.addresses.count }.from(1).to 2
          end

          it 'does not change the existing address' do
            expect{
              form.save
            }.not_to change{ address.reload.country }.from('Norway')
          end
        end

        context 'when the contact have an existing address for the relation but no address details are supplied' do
          let!(:address) { FactoryBot.create(:address, country: 'Norway') }
          let!(:link) { FactoryBot.create(:link, contact: contact, linked: address, relation: 'mail') }
          let(:attr) { { country: '', relation: 'mail' } }

          it { is_expected.to eq true }

          it 'removes the linked address' do
            expect{
              form.save
            }.to change{ contact.addresses.count }.from(1).to 0
          end
        end
      end

    end
  end
end
