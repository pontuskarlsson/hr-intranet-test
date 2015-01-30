require 'spec_helper'

module Refinery
  module Marketing
    describe Show do
      describe 'validations' do
        let(:show) { FactoryGirl.build(:show) }

        it 'validates show presence' do
          expect(show).to be_valid

          show.name = ''
          expect(show).not_to be_valid
        end
        it 'validates name uniqueness' do
          expect(show).to be_valid

          FactoryGirl.create(:show, name: show.name)
          expect(show).not_to be_valid
        end
      end
    end
  end
end
