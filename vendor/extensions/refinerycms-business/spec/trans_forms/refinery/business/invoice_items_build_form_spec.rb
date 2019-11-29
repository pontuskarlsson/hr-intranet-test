require 'spec_helper'

module Refinery
  module Business
    describe InvoiceItemsBuildForm do
      let(:account) { FactoryGirl.create(:account) }
      let(:invoice) { FactoryGirl.create(:invoice, account: account) }
      let(:article) { FactoryGirl.create(:article_voucher, account: account) }
      let(:minimum_attr) { { '0' => { 'article_label' => article.code, 'qty' => 10, 'base_amount' => 100 } } }
      let(:attr) { { invoice_for_month: '2019-01-01', minimums_attributes: minimum_attr } }
      let(:form) { InvoiceItemsBuildForm.new_in_model(invoice, attr) }
      subject { form }

      describe 'validations' do
        it { is_expected.to be_valid }

        context 'when invoice is not associated with a Company' do
          let(:invoice) { FactoryGirl.create(:invoice, company: nil) }

          it { is_expected.not_to be_valid }
        end

        context 'when invoice is not managed' do
          let(:invoice) { FactoryGirl.create(:invoice, is_managed: false) }

          it { is_expected.not_to be_valid }
        end

        context 'when invoice has billables without article code' do
          before { FactoryGirl.create(:billable, invoice: invoice, article: nil) }

          it { is_expected.not_to be_valid }
        end

        context 'when invoice has billables with article code' do
          before { FactoryGirl.create(:billable_with_article, invoice: invoice, account: account) }

          it { is_expected.to be_valid }
        end

        context 'when there are no Billables and no minimum specified' do
          let(:attr) { {  } }

          it { is_expected.not_to be_valid }
        end

        context 'when there are Billables present but no minimum specified' do
          before { FactoryGirl.create(:billable_with_article, invoice: invoice, account: account) }

          let(:attr) { { invoice_for_month: '2019-01-01' } }

          it { is_expected.to be_valid }
        end

        context 'when there are no Billables present but a minimum specified' do
          let(:attr) { { invoice_for_month: '2019-01-01', minimums_attributes: minimum_attr } }

          it { is_expected.to be_valid }
        end

        context 'when there are no Billables present but a minimum specified, but invoice_for_month is missing' do
          let(:attr) { { minimums_attributes: minimum_attr } }

          it { is_expected.not_to be_valid }
        end
      end

      describe '#save' do
        subject { form.save }

        context 'when there are no previous InvoiceItems, no Billables, but a minimum' do
          let(:attr) { { invoice_for_month: '2019-01-01', minimums_attributes: minimum_attr } }

          it { is_expected.to eq true }

          it 'creates InvoiceItems' do
            form.save

            expect( invoice.reload.total_amount ).to eq 1_000
            expect( invoice.invoice_items.sum(:line_amount) ).to eq 1_000

            expect( invoice.invoice_items.sales.sum(:line_amount) ).to eq 1_000
            expect( invoice.invoice_items.sales_offset.sum(:line_amount) ).to eq -1_000
            expect( invoice.invoice_items.discount.sum(:line_amount) ).to eq 0
            expect( invoice.invoice_items.pre_pay.sum(:line_amount) ).to eq 1_000
          end
        end
      end
    end
  end
end
