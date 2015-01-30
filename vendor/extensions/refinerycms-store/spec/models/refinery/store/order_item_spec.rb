require 'spec_helper'

module Refinery
  module Store
    describe OrderItem do
      describe "validations" do
        let(:order_item) { FactoryGirl.build(:order_item) }

        it 'validates product_number presence' do
          expect(order_item).to be_valid

          order_item.product_number = ''
          expect(order_item).not_to be_valid
        end
      end
    end
  end
end
