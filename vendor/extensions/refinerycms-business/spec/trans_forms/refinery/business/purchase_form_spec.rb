require 'spec_helper'

module Refinery
  module Business
    describe PurchaseForm do
      describe '#save' do
        let!(:company) { FactoryBot.create(:verified_company) }
        let!(:user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
            ::Refinery::Business::ROLE_EXTERNAL
        ]) }
        let!(:company_user) { FactoryBot.create(:company_user, company: company, user: user) }
        let(:form) { PurchaseForm.new_in_model(company, attr, user) }
        subject { form }

        before {
          allow(Stripe::Checkout::Session).to receive(:create) { OpenStruct.new(id: SecureRandom.uuid) }
        }

        describe 'for a new Purchase' do
          let(:article) { FactoryBot.create(:article_voucher) }

          context 'when buying 1 voucher' do
            let(:attr) { { article_code: article.code, qty: 1 } }

            it 'creates a Purchase' do
              expect{ form.save }.to change{ Purchase.count }.by(1)
            end
          end

          context 'when buying 2-for-1 vouchers using promo discount' do
            let(:attr) { { article_code: article.code, qty: 2, discount_code: 'SS20PROMO' } }

            it 'creates a Purchase' do
              expect{ form.save }.to change{ Purchase.count }.by(1)

              expect(form.purchase.charges.count).to eq 1
              expect(form.purchase.total_cost).to eq article.sales_unit_price
              expect(form.purchase.sub_total_cost).to eq 2 * article.sales_unit_price
              expect(form.purchase.total_discount).to eq -article.sales_unit_price
            end
          end
        end
      end
    end
  end
end
