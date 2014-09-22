require 'spec_helper'

module Refinery
  module SalesOrders
    describe OrderItem do
      describe 'validations' do
        let(:order_item) FactoryGirl.build(:order_item)

        it 'should be valid' do
          expect(order_item).to be_valid
        end
      end
    end
  end
end
