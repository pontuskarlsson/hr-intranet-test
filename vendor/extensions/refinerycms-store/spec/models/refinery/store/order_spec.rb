require 'spec_helper'

module Refinery
  module Store
    describe Order do
      describe "validations" do
        let(:order) { FactoryGirl.build(:order) }
        it 'validates retailer presence' do
          expect(order).to be_valid

          order.retailer = nil
          expect(order).not_to be_valid
        end
        it 'validates order_number and retailer uniqueness' do
          expect(order).to be_valid

          FactoryGirl.create(:order, order_number: order.order_number, retailer: order.retailer)
          expect(order).not_to be_valid
        end
      end
    end
  end
end
