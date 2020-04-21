require 'spec_helper'

module Refinery
  module Business
    describe Voucher do
      describe 'validations' do
        let(:voucher) { FactoryBot.build(:voucher) }
        subject { voucher }

        it { is_expected.to be_valid }

        context 'when :company is missing' do
          before { voucher.company = nil }

          it { is_expected.not_to be_valid }
        end

      end
    end
  end
end
