require 'spec_helper'

module Refinery
  module Business
    describe BudgetForm do
      describe '#save' do
        let(:form) { BudgetForm.new_in_model(budget, attr) }
        subject { form }

        describe 'for a new Budget' do
          let(:budget) { Budget.new }

          context 'when BudgetItem attributes are present but empty or zero' do
            let(:attr) { { description: 'Budget Q4', from_date: '2011-02-03', to_date: '2011-04-05', comments: 'new comments', customer_name: 'Company Ltd.',
               budget_items_attributes: { '0' => { description: '', quantity: '0', price: '0', margin_percent: '0.0' } }
            } }

            it 'creates a Budget' do
              expect{ form.save }.to change{ Budget.count }.by(1)
              expect( Budget.last.description ).to    eq attr[:description]
              expect( Budget.last.from_date).to       eq attr[:from_date].to_date
              expect( Budget.last.to_date ).to        eq attr[:to_date].to_date
              expect( Budget.last.comments ).to       eq attr[:comments]
              expect( Budget.last.customer_name ).to  eq attr[:customer_name]
            end

            it 'does not create an BudgetItem' do
              expect{ form.save }.to change{ BudgetItem.count }.by(0)
            end
          end

          context 'when BudgetItem attributes are present and have values' do
            let(:attr) { { description: 'Budget Q4', from_date: '2011-02-03', to_date: '2011-04-05', comments: 'new comments', customer_name: 'Company Ltd.',
               budget_items_attributes: { '0' => { description: 'T-Shirts', no_of_products: '10', no_of_skus: '20', price: '9.50', quantity: '100', margin_percent: '20', comments: 'T-Shirt comments' } }
            } }

            it 'creates a Budget' do
              expect{ form.save }.to change{ Budget.count }.by(1)
            end

            it 'does not create an BudgetItem' do
              expect{ form.save }.to change{ BudgetItem.count }.by(1)
              expect( BudgetItem.last.description ).to    eq attr[:budget_items_attributes]['0'][:description]
              expect( BudgetItem.last.no_of_products ).to eq attr[:budget_items_attributes]['0'][:no_of_products].to_i
              expect( BudgetItem.last.no_of_skus ).to     eq attr[:budget_items_attributes]['0'][:no_of_skus].to_i
              expect( BudgetItem.last.price ).to          eq attr[:budget_items_attributes]['0'][:price].to_f
              expect( BudgetItem.last.quantity ).to       eq attr[:budget_items_attributes]['0'][:quantity].to_i
              expect( BudgetItem.last.margin ).to         eq attr[:budget_items_attributes]['0'][:margin_percent].to_f / 100.0
              expect( BudgetItem.last.comments ).to       eq attr[:budget_items_attributes]['0'][:comments]
            end
          end

          context 'when an existing Contact matches the :customer_name' do
            let(:contact) { FactoryGirl.create(:contact) }
            let(:attr) { { description: 'Budget Q4', from_date: '2011-02-03', to_date: '2011-04-05', comments: 'new comments', customer_name: contact.name } }

            it 'creates a Budget' do
              expect{ form.save }.to change{ Budget.count }.by(1)
              expect( Budget.last.customer_contact ).to eq contact
              expect( Budget.last.customer_name ).to eq contact.name
            end
          end
        end

        describe 'for an existing Budget' do
          let(:budget) { FactoryGirl.create(:budget) }
          before { budget } # Makes sure it is created to handle counters correctly

          context 'when updated attributes are present' do
            let(:attr) { { description: 'New Description', from_date: '2011-12-13', to_date: '2012-11-23', comments: 'The is a better way', customer_name: 'Other Company Ltd.' } }

            it 'updates attributes of existing Budget' do
              expect{ form.save }.to change{ Budget.count }.by(0)
              expect( Budget.last.description ).to    eq attr[:description]
              expect( Budget.last.from_date).to       eq attr[:from_date].to_date
              expect( Budget.last.to_date ).to        eq attr[:to_date].to_date
              expect( Budget.last.comments ).to       eq attr[:comments]
              expect( Budget.last.customer_name ).to  eq attr[:customer_name]
            end
          end
        end
      end
    end
  end
end
