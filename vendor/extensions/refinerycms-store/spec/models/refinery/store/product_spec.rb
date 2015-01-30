require 'spec_helper'

module Refinery
  module Store
    describe Product do
      describe "validations" do
        let(:product) { FactoryGirl.build(:product) }

        it 'validates product_number presence' do
          expect(product).to be_valid

          product.product_number = ''
          expect(product).not_to be_valid
        end
        it 'validates product_number and retailer uniqueness' do
          expect(product).to be_valid

          FactoryGirl.create(:product, product_number: product.product_number, retailer: product.retailer)
          expect(product).not_to be_valid
        end
      end
    end
  end
end
