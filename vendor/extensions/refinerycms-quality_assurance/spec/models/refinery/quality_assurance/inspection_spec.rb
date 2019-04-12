require 'spec_helper'

module Refinery
  module QualityAssurance
    describe Inspection do
      describe "validations", type: :model do
        subject do
          FactoryGirl.create(:inspection)
        end

        it { should be_valid }
        its(:errors) { should be_empty }
      end
    end
  end
end
