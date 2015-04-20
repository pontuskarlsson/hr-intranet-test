require 'spec_helper'

module Refinery
  module Business
    describe BudgetItem do
      describe 'validations' do
        let(:budget_item) { FactoryGirl.build(:budget_item) }
        subject { budget_item }

        it { is_expected.to be_valid }

        context 'when :budget is missing' do
          before { budget_item.budget = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :description is missing' do
          before { budget_item.description = nil }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
