require 'spec_helper'

module Refinery
  module Marketing
    describe Contact do
      describe 'validations' do
        let(:contact) { FactoryBot.build(:contact) }
        subject { contact }

        it { is_expected.to be_valid }

        context 'when both name and email is missing' do
          before { contact.name = ''; contact.email = '' }
          it { is_expected.not_to be_valid }
        end

        context 'when insightly_id is already present' do
          before {
            contact.insightly_id = '123456789'
            FactoryBot.create(:contact, insightly_id: contact.insightly_id)
          }
          it { is_expected.not_to be_valid }
        end

        context 'when User is already present' do
          before {
            contact.user = FactoryBot.create(:authentication_devise_user)
            FactoryBot.create(:contact, user: contact.user)
          }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
