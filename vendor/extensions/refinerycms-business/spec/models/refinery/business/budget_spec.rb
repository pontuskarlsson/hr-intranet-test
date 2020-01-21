require 'spec_helper'

module Refinery
  module Business
    describe Budget do
      describe 'validations' do
        let(:budget) { FactoryBot.build(:budget) }
        subject { budget }

        it { is_expected.to be_valid }

        context 'when :description is missing' do
          before { budget.description = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :description is already present' do
          before { FactoryBot.create(:budget, description: budget.description) }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
