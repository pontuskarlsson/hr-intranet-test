require 'spec_helper'

module Refinery
  module Business
    describe CompanyBillingForm do
      let!(:company) { FactoryBot.create(:company) }
      let(:attr) { {  } }
      let(:form) { CompanyBillingForm.new_in_model(company, attr) }
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

        context 'when creating a new billing account' do
          let(:attr) { { billing_accounts_attributes: {
              '0' => {
                  email_addresses: 'john.doe@email.com',
              },
          } } }

          it { is_expected.to eq true }

          it 'creates a new billing account' do
            expect{
              form.save
            }.to change{ company.billing_accounts.count }.from(0).to 1

            expect( company.billing_accounts[0]&.email_addresses ).to eq 'john.doe@email.com'
          end
        end
      end

    end
  end
end
