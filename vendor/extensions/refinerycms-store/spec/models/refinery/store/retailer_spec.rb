require 'spec_helper'

module Refinery
  module Store
    describe Retailer do
      describe "validations" do
        let(:retailer) { FactoryGirl.build(:retailer) }

        it 'validates name presence' do
          expect(retailer).to be_valid

          retailer.name = ''
          expect(retailer).not_to be_valid
        end
        it 'validates name uniqueness' do
          expect(retailer).to be_valid

          FactoryGirl.create(:retailer, name: retailer.name)
          expect(retailer).not_to be_valid
        end
      end
    end
  end
end
