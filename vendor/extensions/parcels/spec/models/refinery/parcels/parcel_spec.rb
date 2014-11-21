require 'spec_helper'

module Refinery
  module Parcels
    describe Parcel do
      describe "validations" do
        let(:parcel) { FactoryGirl.build(:parcel) }

        it 'validates received by presence' do
          expect( parcel ).to be_valid

          parcel.received_by = nil
          expect( parcel ).not_to be_valid
        end
      end
    end
  end
end
