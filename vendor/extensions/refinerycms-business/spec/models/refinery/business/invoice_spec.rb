require 'spec_helper'

module Refinery
  module Business
    describe Invoice do
      describe 'validations' do
        let(:invoice) { FactoryGirl.build(:invoice) }
        subject { invoice }

        it { is_expected.to be_valid }

        context 'when :invoice_id is already present' do
          let(:invoice) { FactoryGirl.build(:invoice_with_id) }

          before { FactoryGirl.create(:invoice, invoice_id: invoice.invoice_id) }

          it { is_expected.not_to be_valid }
        end

      end
    end
  end
end
