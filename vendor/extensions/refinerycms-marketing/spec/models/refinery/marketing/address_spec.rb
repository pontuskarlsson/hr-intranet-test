require 'spec_helper'

module Refinery
  module Marketing
    describe Address do
      describe 'validations' do
        let(:address) { FactoryBot.build(:address) }
        subject { address }

        it { is_expected.to be_valid }

        context 'when :country is blank' do
          before { address.country = '' }
          it { is_expected.not_to be_valid }
        end

      end
    end
  end
end
