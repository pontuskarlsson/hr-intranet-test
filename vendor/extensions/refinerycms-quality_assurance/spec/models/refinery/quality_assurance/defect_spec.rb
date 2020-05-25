require 'spec_helper'

module Refinery
  module QualityAssurance
    describe Defect do
      describe 'validations' do
        let(:defect) { FactoryBot.build(:defect) }
        subject { defect }

        it { is_expected.to be_valid }

        context 'when :category_code and :defect_code is already present' do
          before { FactoryBot.create(:defect, category_code: defect.category_code, defect_code: defect.defect_code) }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
