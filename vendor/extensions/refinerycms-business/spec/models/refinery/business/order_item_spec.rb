require 'spec_helper'

module Refinery
  module Business
    describe OrderItem do
      describe 'validations' do
        let(:order_item) { FactoryGirl.build(:order_item) }
        subject { order_item }

        it { is_expected.to be_valid }

        context 'when :sales_order is missing' do
          before { order_item.sales_order = nil }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
