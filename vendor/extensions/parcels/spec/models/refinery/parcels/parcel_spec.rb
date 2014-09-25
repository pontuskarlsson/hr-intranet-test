require 'spec_helper'

module Refinery
  module Parcels
    describe Parcel do
      describe "validations" do
        subject do
          FactoryGirl.create(:parcel,
          :from_name => "Refinery CMS")
        end

        it { should be_valid }
        its(:errors) { should be_empty }
        its(:from_name) { should == "Refinery CMS" }
      end
    end
  end
end
