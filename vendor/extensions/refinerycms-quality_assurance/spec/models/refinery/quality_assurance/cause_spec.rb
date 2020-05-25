require 'spec_helper'

module Refinery
  module QualityAssurance
    describe Cause do
      describe 'validations' do
        let(:cause) { FactoryBot.build(:cause) }
        subject { cause }

        it { is_expected.to be_valid }

        context 'when :category_code and :cause_code is already present' do
          before { FactoryBot.create(:cause, category_code: cause.category_code, cause_code: cause.cause_code) }
          it { is_expected.not_to be_valid }
        end

        context 'when only :cause_name is present' do
          before { cause.category_code = nil; cause.category_name = nil; cause.cause_code = nil }
          it { is_expected.to be_valid }
        end

        context 'when :category_code is present but not :cause_code' do
          before { cause.cause_code = nil }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
