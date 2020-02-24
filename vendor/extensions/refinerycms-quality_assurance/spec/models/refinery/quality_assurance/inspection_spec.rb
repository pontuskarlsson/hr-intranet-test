require 'spec_helper'

module Refinery
  module QualityAssurance
    describe Inspection do
      describe 'validations' do
        let(:inspection) { FactoryBot.build(:inspection) }
        subject { inspection }

        it { is_expected.to be_valid }

        context 'when :inspection_type is missing' do
          before { inspection.inspection_type = nil }
          it { is_expected.to be_valid }
        end

        context 'when :inspection_type is present but not one of allowed values' do
          before { inspection.inspection_type = 'Not valid type' }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
