require 'rails_helper'

module Refinery
  module Business
    describe BudgetForm do
      describe 'validations' do
        let(:budget_form) { BudgetForm.new_in_model(Budget.new, { description: 'Budget plan for 2015 - Q1', customer_name: 'Company Ltd.', year: '2015', quarter: 'Q1' }) }
        subject { budget_form }

        it { is_expected.to be_valid }

        context 'when :year is missing' do
          before { budget_form.year = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :year is not a four digit year' do
          before { budget_form.year = '12' }
          it { is_expected.not_to be_valid }
        end

        context 'when :quarter is missing' do
          before { budget_form.quarter = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :quarter is not a valid Quarter' do
          before { budget_form.quarter = 'Q5' }
          it { is_expected.not_to be_valid }
        end
      end

      describe '#save' do
        let(:form) { BudgetForm.new_in_model(budget, attr) }
        subject { form }

        describe 'for a new Budget' do
          let(:budget) { Budget.new }

          context 'when assigning :year and :quarter' do
            let(:attr) { { description: 'Budget Q4', customer_name: 'Company Ltd.', year: '2012', quarter: 'Q3' } }

            it 'creates a Budget and translates year and quarter into from and to dates' do
              expect{ form.save }.to change{ Budget.count }.by(1)
              expect( Budget.last.from_date ).to      eq Date.new(2012, 7, 1)
              expect( Budget.last.to_date ).to        eq Date.new(2012, 9, 30)
            end
          end

        end

        describe 'for an existing Budget' do

        end
      end
    end
  end
end
