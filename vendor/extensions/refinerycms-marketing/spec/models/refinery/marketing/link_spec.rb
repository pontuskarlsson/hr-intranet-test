require 'spec_helper'

module Refinery
  module Marketing
    describe Link do
      describe 'validations' do
        let(:link) { FactoryBot.build(:link) }
        subject { link }

        it { is_expected.to be_valid }

        context 'when :contact is missing' do
          before { link.contact = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :linked is missing' do
          before { link.linked = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :relation is missing' do
          before { link.relation = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :contact and :linked does not have the same owner' do
          before { link.linked = FactoryBot.create(:address, owner: FactoryBot.create(:company)) }
          it { is_expected.not_to be_valid }
        end

        context 'when :contact and :linked does have the same owner' do
          before {
            link.contact = FactoryBot.create(:contact, owner: FactoryBot.create(:company))
            link.linked = FactoryBot.create(:address, owner: link.contact.owner)
          }
          it { is_expected.to be_valid }
        end

        context 'when neither :contact nor :linked have an owner' do
          before {
            link.contact = FactoryBot.create(:contact, owner: nil)
            link.linked = FactoryBot.create(:address, owner: nil)
          }
          it { is_expected.to be_valid }
        end

      end
    end
  end
end
