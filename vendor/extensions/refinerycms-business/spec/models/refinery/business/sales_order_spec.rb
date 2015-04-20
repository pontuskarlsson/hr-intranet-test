require 'spec_helper'

module Refinery
  module Business
    describe SalesOrder do
      describe 'validations' do
        let(:sales_order) { FactoryGirl.build(:sales_order) }
        subject { sales_order }

        it { is_expected.to be_valid }

        context 'when :order_ref is missing' do
          before { sales_order.order_ref = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :order_ref is already present' do
          before { FactoryGirl.create(:sales_order, order_ref: sales_order.order_ref) }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
