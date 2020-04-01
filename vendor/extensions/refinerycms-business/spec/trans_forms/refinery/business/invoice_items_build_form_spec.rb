require 'spec_helper'

module Refinery
  module Business
    describe InvoiceItemsBuildForm do
      let(:account) { FactoryBot.create(:account) }
      let(:invoice) { FactoryBot.create(:invoice, account: account) }
      let(:work_article) { FactoryBot.create(:article, account: account) }
      let(:article) { FactoryBot.create(:article_voucher, account: account, voucher_constraint_applicable_articles: [work_article.code]) }
      let(:minimum_attr) { { '0' => { 'article_label' => article.code, 'qty' => 10, 'base_amount' => 100 } } }
      let(:minimum_with_discount_attr) { { '0' => { 'article_label' => article.code, 'qty' => 10, 'base_amount' => 100, 'discount_type' => 'fixed_amount', 'discount_amount' => '-10' } } }
      let(:attr) { { invoice_for_month: '2019-01-01', minimums_attributes: minimum_attr } }
      let(:form) { InvoiceItemsBuildForm.new_in_model(invoice, attr) }
      subject { form }

      describe 'validations' do
        it { is_expected.to be_valid }

        context 'when invoice is not associated with a Company' do
          let(:invoice) { FactoryBot.create(:invoice, company: nil) }

          it { is_expected.not_to be_valid }
        end

        context 'when invoice is not managed' do
          let(:invoice) { FactoryBot.create(:invoice, is_managed: false) }

          it { is_expected.not_to be_valid }
        end

        context 'when invoice has billables without article code' do
          before { FactoryBot.create(:billable, company: invoice.company, invoice: invoice, article: nil) }

          it { is_expected.not_to be_valid }
        end

        context 'when invoice has billables with article code' do
          before { FactoryBot.create(:billable_with_article, company: invoice.company, invoice: invoice, account: account) }

          it { is_expected.to be_valid }
        end

        context 'when there are no Billables and no minimum specified' do
          let(:attr) { {  } }

          it { is_expected.not_to be_valid }
        end

        context 'when there are Billables present but no minimum specified' do
          before { FactoryBot.create(:billable_with_article, company: invoice.company, invoice: invoice, account: account) }

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

      describe '#save!' do
        subject { form.save! }

        context 'when there are no previous InvoiceItems, no Billables, but a minimum' do
          let(:attr) { { invoice_for_month: '2019-01-01', minimums_attributes: minimum_attr } }

          it { is_expected.to eq true }

          it 'creates InvoiceItems' do
            form.save

            expect( invoice.reload.total_amount ).to eq 1_000
            expect( invoice.invoice_items.transactional.count ).to eq 10 # one for each voucher
            expect( invoice.invoice_items.sum(:line_amount) ).to eq 1_000

            # expect( invoice.invoice_items.sales.sum(:line_amount) ).to eq 1_000
            # expect( invoice.invoice_items.sales_offset.sum(:line_amount) ).to eq -1_000
            # expect( invoice.invoice_items.discount.sum(:line_amount) ).to eq 0
            # expect( invoice.invoice_items.pre_pay.sum(:line_amount) ).to eq 1_000
            expect( invoice.invoice_items.prepay_in.count ).to eq 10
            expect( invoice.invoice_items.prepay_in.sum(:line_amount) ).to eq 1_000
          end
        end

        context 'when there are no previous InvoiceItems, no Billables, but a minimum with discount' do
          let(:attr) { { invoice_for_month: '2019-01-01', minimums_attributes: minimum_with_discount_attr } }

          it { is_expected.to eq true }

          it 'creates InvoiceItems' do
            form.save

            expect( invoice.reload.total_amount ).to eq 900

            expect( invoice.invoice_items.transactional.count ).to eq 20 # two for each voucher
            expect( invoice.invoice_items.sum(:line_amount) ).to eq 900

            # expect( invoice.invoice_items.sales.sum(:line_amount) ).to eq 1_000
            # expect( invoice.invoice_items.sales_offset.sum(:line_amount) ).to eq -1_000
            # expect( invoice.invoice_items.discount.sum(:line_amount) ).to eq 0
            # expect( invoice.invoice_items.pre_pay.sum(:line_amount) ).to eq 1_000
            expect( invoice.invoice_items.prepay_in.count ).to eq 10
            expect( invoice.invoice_items.prepay_in.sum(:line_amount) ).to eq 1_000
            expect( invoice.invoice_items.prepay_discount_in.count ).to eq 10
            expect( invoice.invoice_items.prepay_discount_in.sum(:line_amount) ).to eq -100
          end
        end

        context 'when there are no previous InvoiceItems, Billables, but no minimum' do
          let(:billable) { FactoryBot.create(:billable_with_article, company: invoice.company, invoice: invoice, article_sales_unit_price: 5_432) }
          let(:attr) { { invoice_for_month: '2019-01-01', minimums_attributes: {} } }

          before { billable }

          it { is_expected.to eq true }

          it 'creates InvoiceItems' do
            form.save

            expect( invoice.reload.total_amount ).to eq 5_432
            expect( invoice.invoice_items.transactional.count ).to eq 1
            expect( invoice.invoice_items.sum(:line_amount) ).to eq 5_432

            # expect( invoice.invoice_items.sales.sum(:line_amount) ).to eq 5_432
            # expect( invoice.invoice_items.sales_offset.sum(:line_amount) ).to eq 0
            # expect( invoice.invoice_items.discount.sum(:line_amount) ).to eq 0
            # expect( invoice.invoice_items.pre_pay.sum(:line_amount) ).to eq 0
            expect( invoice.invoice_items.sales_purchase.count ).to eq 1
            expect( invoice.invoice_items.sales_purchase.sum(:line_amount) ).to eq 5_432
          end
        end

        context 'when there are no previous InvoiceItems, Billables, and a minimum with discount' do
          let(:billable) { FactoryBot.create(:billable_with_article, company: invoice.company, article: work_article, invoice: invoice) }
          let(:attr) { { invoice_for_month: '2019-01-01', minimums_attributes: minimum_with_discount_attr } }

          before { billable }

          it { is_expected.to eq true }

          it 'creates InvoiceItems' do
            form.save

            expect( invoice.reload.total_amount ).to eq 900

            expect( invoice.invoice_items.transactional.count ).to eq 20 # two for each voucher
            expect( invoice.invoice_items.sum(:line_amount) ).to eq 900

            expect( invoice.invoice_items.sales_purchase.count ).to eq 1
            expect( invoice.invoice_items.sales_purchase.sum(:line_amount) ).to eq 100

            expect( invoice.invoice_items.sales_discount.count ).to eq 1
            expect( invoice.invoice_items.sales_discount.sum(:line_amount) ).to eq -10

            expect( invoice.invoice_items.prepay_in.count ).to eq 9
            expect( invoice.invoice_items.prepay_in.sum(:line_amount) ).to eq 900

            expect( invoice.invoice_items.prepay_discount_in.count ).to eq 9
            expect( invoice.invoice_items.prepay_discount_in.sum(:line_amount) ).to eq -90
          end
        end

        context 'when there are no previous InvoiceItems, Billables, a minimum with discount, and a prior voucher' do
          let!(:voucher_article) { FactoryBot.create(:article_voucher, applicable_to: work_article) }
          let!(:voucher) { FactoryBot.create(:voucher, company: invoice.company, article: voucher_article) }
          let!(:billable) { FactoryBot.create(:billable_with_article, company: invoice.company, article: work_article, invoice: invoice) }
          let(:attr) { { invoice_for_month: '2019-01-01', minimums_attributes: minimum_with_discount_attr } }

          before { billable }

          it { is_expected.to eq true }

          it 'creates InvoiceItems' do
            form.save

            expect( invoice.reload.total_amount ).to eq 900

            expect( invoice.invoice_items.transactional.count ).to eq 20 # two for each voucher
            expect( invoice.invoice_items.sum(:line_amount) ).to eq 900

            expect( invoice.invoice_items.sales_purchase.count ).to eq 1
            expect( invoice.invoice_items.sales_purchase.sum(:line_amount) ).to eq 100

            expect( invoice.invoice_items.sales_discount.count ).to eq 1
            expect( invoice.invoice_items.sales_discount.sum(:line_amount) ).to eq -10

            expect( invoice.invoice_items.prepay_in.count ).to eq 9
            expect( invoice.invoice_items.prepay_in.sum(:line_amount) ).to eq 900

            expect( invoice.invoice_items.prepay_discount_in.count ).to eq 9
            expect( invoice.invoice_items.prepay_discount_in.sum(:line_amount) ).to eq -90
          end
        end

        context 'when there are two Billables, one of them is flagged to bill Happy Rabbit, no voucher and a minimum of 10 vouchers invoiced' do
          let!(:own_billable) { FactoryBot.create(:billable_with_article, company: invoice.company, article: work_article, invoice: invoice) }
          let!(:hr_billable) { FactoryBot.create(:billable_with_article, company: invoice.company, article: work_article, invoice: invoice, bill_happy_rabbit: true) }
          let(:attr) { { invoice_for_month: '2019-01-01', minimums_attributes: minimum_attr } }

          it { is_expected.to eq true }

          it 'creates InvoiceItems' do
            form.save

            expect( invoice.reload.total_amount ).to eq 1_000

            expect( invoice.invoice_items.transactional.count ).to eq 10 # one for each own billable or voucher issued
            expect( invoice.invoice_items.sum(:line_amount) ).to eq 1_000

            expect( invoice.invoice_items.sales_purchase.count ).to eq 1
            expect( invoice.invoice_items.sales_purchase.sum(:line_amount) ).to eq 100

            expect( invoice.invoice_items.sales_discount.count ).to eq 0
            expect( invoice.invoice_items.sales_discount.sum(:line_amount) ).to eq 0

            expect( invoice.invoice_items.prepay_in.count ).to eq 9
            expect( invoice.invoice_items.prepay_in.sum(:line_amount) ).to eq 900

            expect( invoice.invoice_items.prepay_discount_in.count ).to eq 0
            expect( invoice.invoice_items.prepay_discount_in.sum(:line_amount) ).to eq 0

            expect( own_billable.reload.line_item_sales ).to be_present
            expect( hr_billable.reload.line_item_sales ).not_to be_present
          end
        end

        context 'when there are two Billables, one of them is flagged to bill Happy Rabbit, no voucher and no minimum' do
          let(:work_article) { FactoryBot.create(:article, account: account, sales_unit_price: 200) }
          let!(:own_billable) { FactoryBot.create(:billable_with_article, company: invoice.company, article: work_article, invoice: invoice) }
          let!(:hr_billable) { FactoryBot.create(:billable_with_article, company: invoice.company, article: work_article, invoice: invoice, bill_happy_rabbit: true) }
          let(:attr) { { invoice_for_month: '2019-01-01', minimums_attributes: {} } }

          it { is_expected.to eq true }

          it 'creates InvoiceItems' do
            form.save

            expect( invoice.reload.total_amount ).to eq 200

            expect( invoice.invoice_items.transactional.count ).to eq 1 # one for the own billable
            expect( invoice.invoice_items.sum(:line_amount) ).to eq 200

            expect( invoice.invoice_items.sales_purchase.count ).to eq 1
            expect( invoice.invoice_items.sales_purchase.sum(:line_amount) ).to eq 200

            expect( invoice.invoice_items.sales_discount.count ).to eq 0
            expect( invoice.invoice_items.sales_discount.sum(:line_amount) ).to eq 0

            expect( invoice.invoice_items.prepay_in.count ).to eq 0
            expect( invoice.invoice_items.prepay_in.sum(:line_amount) ).to eq 0

            expect( invoice.invoice_items.prepay_discount_in.count ).to eq 0
            expect( invoice.invoice_items.prepay_discount_in.sum(:line_amount) ).to eq 0

            expect( own_billable.reload.line_item_sales ).to be_present
            expect( hr_billable.reload.line_item_sales ).not_to be_present
          end
        end
      end
    end
  end
end
