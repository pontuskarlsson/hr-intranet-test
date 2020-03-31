require 'spec_helper'

module Refinery
  module Business
    describe InvoiceItem do
      describe 'validations' do
        let(:invoice_item) { FactoryBot.build(:invoice_item) }
        subject { invoice_item }

        it { is_expected.to be_valid }

        context 'when :invoice is missing' do
          before { invoice_item.invoice = nil }

          it { is_expected.not_to be_valid }
        end

        context 'when :transaction_type is "sales_purchase"' do
          let(:invoice_item) { FactoryBot.build(:invoice_item_sales_purchase) }

          it { is_expected.to be_valid }

          context 'but article is missing' do
            before { invoice_item.article = nil }

            it { is_expected.not_to be_valid }
          end

          context 'but :unit_amount is missing' do
            before { invoice_item.unit_amount = nil }

            it { is_expected.not_to be_valid }
          end

          context 'but :quantity is missing' do
            before { invoice_item.quantity = nil }

            it { is_expected.not_to be_valid }
          end
        end
      end

      describe '#save' do
        let(:invoice_item) { FactoryBot.build(:invoice_item) }
        subject { invoice_item.save }

        context 'when :transaction_type is missing' do
          it { is_expected.to eq true }

          it 'does not assign an account code' do
            expect{
              invoice_item.save
            }.not_to change{ invoice_item.account_code }.from nil
          end
        end

        context 'when :transaction_type is sales_purchase' do
          let(:invoice_item) { FactoryBot.build(:invoice_item_sales_purchase) }

          it { is_expected.to eq true }

          it 'assigns an account code' do
            expect{
              invoice_item.save
            }.to change{ invoice_item.account_code }.from nil
          end
        end
      end

      describe '#destroy' do
        let(:invoice_item) { FactoryBot.create(:invoice_item) }
        subject { invoice_item.destroy! }

        it { is_expected.to be_destroyed }

        context 'when it has issued a voucher that is now redeemed' do
          it 'raises and error when trying to destroy' do
            pending 'add specs'
            expect{
              invoice_item.destroy!
            }.to raise_error ActiveRecord::RecordNotDestroyed
          end
        end

        context 'when it redeemed a voucher that is still in "reserved" status' do
          it "removes the reserved status, making it available again" do
            pending 'add specs'
            expect{
              invoice_item.destroy!
            }.to change{ 'reserved' }.from('reserved').to 'active'
          end
        end

        context 'when it redeemed a voucher that has fully transitioned to "redeemed" status' do
          it "removes the reserved status, making it available again" do
            pending 'add specs'

            expect{
              invoice_item.destroy!
            }.to raise_error ActiveRecord::RecordNotDestroyed
          end
        end
      end
    end
  end
end
