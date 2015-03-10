require 'spec_helper'

module Refinery
  module Marketing
    describe Contact do
      describe 'validations' do
        let(:contact) { FactoryGirl.build(:contact) }
        subject { contact }

        it { is_expected.to be_valid }

        context 'when base_id is missing' do
          before { contact.base_id = '' }
          it { is_expected.not_to be_valid }
        end

        context 'when base_id is already present' do
          before { FactoryGirl.create(:contact, base_id: contact.base_id) }
          it { is_expected.not_to be_valid }
        end

        context 'when name is missing' do
          before { contact.name = '' }
          it { is_expected.not_to be_valid }
        end

        context 'when User is already present' do
          before {
            contact.user = FactoryGirl.create(:user)
            FactoryGirl.create(:contact, user: contact.user)
          }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
