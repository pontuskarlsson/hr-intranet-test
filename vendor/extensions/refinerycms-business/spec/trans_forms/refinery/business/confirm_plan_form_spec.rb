require 'spec_helper'

module Refinery
  module Business
    describe ConfirmPlanForm do
      let!(:company) { FactoryBot.create(:verified_company) }
      let!(:plan) { FactoryBot.create(:proposed_plan, company: company) }
      let!(:current_user) { FactoryBot.create(:authentication_devise_user_with_roles, role_titles: [
          ::Refinery::Business::ROLE_EXTERNAL
      ]) }
      let!(:company_user) { FactoryBot.create(:company_user, company: company, user: current_user) }

      let(:attr) { { confirmed_by_id: current_user.id } }
      let(:form) { ConfirmPlanForm.new_in_model(plan, attr, current_user) }
      subject { form }

      describe 'validations' do
        it { is_expected.to be_valid }

        context 'when plan proposal has expired' do
          let!(:plan) { FactoryBot.create(:proposed_plan, company: company, proposal_valid_until: 1.day.ago) }

          it { is_expected.not_to be_valid }
        end

      end

    end
  end
end
