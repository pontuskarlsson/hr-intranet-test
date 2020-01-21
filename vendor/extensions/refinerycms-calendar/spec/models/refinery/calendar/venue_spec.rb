require 'spec_helper'

module Refinery
  module Calendar
    describe Venue do
      describe "validations" do
        let(:venue) { FactoryBot.build(:venue) }
        it 'validates name presence' do
          expect( venue ).to be_valid

          venue.name = ''
          expect( venue ).to_not be_valid
        end
      end
    end
  end
end
