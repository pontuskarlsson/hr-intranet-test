require 'spec_helper'

module Refinery
  module Marketing
    describe Brand do
      describe 'validations' do
        let(:brand) { FactoryGirl.build(:brand) }

        it 'validates name presence' do
          expect(brand).to be_valid

          brand.name = ''
          expect(brand).not_to be_valid
        end
        it 'validates name uniqueness' do
          expect(brand).to be_valid

          FactoryGirl.create(:brand, name: brand.name)
          expect(brand).not_to be_valid
        end
      end
    end
  end
end
