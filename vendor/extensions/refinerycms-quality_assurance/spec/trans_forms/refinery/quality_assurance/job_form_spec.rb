require 'spec_helper'

module Refinery
  module QualityAssurance
    describe JobForm do
      let!(:job) { FactoryBot.create(:job) }
      let(:attr) { {  } }
      let(:form) { JobForm.new_in_model(job, attr) }
      subject { form }

      describe 'validations' do
        it { is_expected.to be_valid }

        # context 'when plan proposal has expired' do
        #   let!(:plan) { FactoryBot.create(:proposed_plan, company: company, proposal_valid_until: 1.day.ago) }
        #
        #   it { is_expected.not_to be_valid }
        # end

      end

      describe '#save' do
        subject { form.save }

        context 'when assigning a project, product_category and complexity' do
          let!(:project) { FactoryBot.create(:project, company: job.company) }
          let(:attr) { { project_label: project.label, product_category: 'Footwear', complexity: 'low' } }

          it { is_expected.to eq true }

          it 'assigns the project' do
            expect{
              form.save
            }.to change{ job.reload.project }.from(nil).to project

            expect( job.complexity ).to eq 'low'
            expect( job.product_category ).to eq 'Footwear'
          end
        end

        context 'when assigning multiple purchase orders' do
          let(:attr) { { purchase_orders_attributes: {
              '0' => { code: 'PO1' },
              '1' => { code: 'PO2' },
          } } }

          it { is_expected.to eq true }

          it 'assigns the purchase orders' do
            expect{
              form.save
            }.to change{ job.purchase_orders.count }.from(0).to 2

            expect( job.purchase_orders[0]&.code ).to eq 'PO1'
            expect( job.purchase_orders[1]&.code ).to eq 'PO2'
          end
        end

        context 'when assigning multiple products' do
          let(:attr) { { products_attributes: {
              '0' => { code: 'Product1' },
              '1' => { code: 'Product2' },
          } } }

          it { is_expected.to eq true }

          it 'assigns the products' do
            expect{
              form.save
            }.to change{ job.products.count }.from(0).to 2

            expect( job.products[0]&.code ).to eq 'Product1'
            expect( job.products[1]&.code ).to eq 'Product2'
          end
        end
      end

    end
  end
end
