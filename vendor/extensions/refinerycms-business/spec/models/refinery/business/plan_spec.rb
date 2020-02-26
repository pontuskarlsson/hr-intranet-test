require 'spec_helper'

module Refinery
  module Business
    describe Plan do
      describe 'validations' do
        let(:plan) { FactoryBot.build(:plan) }
        subject { plan }

        it { is_expected.to be_valid }

        context 'when :company_id is missing' do
          before { plan.company_id = nil }

          it { is_expected.not_to be_valid }
        end

        context 'when :contact_person is missing' do
          before { plan.contact_person = nil }

          it { is_expected.not_to be_valid }
        end

        context 'when :contact_person does not have access to company' do
          before { plan.contact_person = FactoryBot.create(:authentication_devise_user) }

          it { is_expected.not_to be_valid }
        end

        context 'when :contact_person does have access to company' do
          before { plan.contact_person = FactoryBot.create(:company_user, company: plan.company).user }

          it { is_expected.to be_valid }
        end

        context 'when :account_manager is missing' do
          before { plan.account_manager = nil }

          it { is_expected.not_to be_valid }
        end

        context 'when :account_manager is not an internal user' do
          before { plan.account_manager = FactoryBot.create(:authentication_devise_user) }

          it { is_expected.not_to be_valid }
        end

        context 'when :account_manager is an internal user' do
          let(:internal_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
              ::Refinery::Business::ROLE_INTERNAL
          ]) }
          before { plan.account_manager = internal_user }

          it { is_expected.to be_valid }
        end

        context 'when :payment_terms_type requires a qty, but qty is missing' do
          before {
            plan.payment_terms_type = 'X_days_after_invoice_date'
            plan.payment_terms_qty = nil
          }

          it { is_expected.not_to be_valid }
        end

        context 'when :payment_terms_type requires a qty, but qty is not a number' do
          before {
            plan.payment_terms_type = 'X_days_after_invoice_date'
            plan.payment_terms_qty = 'NotANumber'
          }

          it { is_expected.not_to be_valid }
        end

        context 'when :payment_terms_type requires a qty, and qty is present' do
          before {
            plan.payment_terms_type = 'X_days_after_invoice_date'
            plan.payment_terms_qty = '30'
          }

          it { is_expected.to be_valid }
        end

      end
    end
  end
end
