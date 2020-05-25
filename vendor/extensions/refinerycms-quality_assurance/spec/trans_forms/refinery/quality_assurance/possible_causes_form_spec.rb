require 'spec_helper'

module Refinery
  module QualityAssurance
    describe PossibleCausesForm do
      let!(:defect) { FactoryBot.create(:defect) }
      let(:attr) { {  } }
      let(:form) { PossibleCausesForm.new_in_model(defect, attr) }
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

        context 'when creating a new cause and adding as a possible cause' do
          let(:attr) { { possible_causes_attributes: {
              '0' => {
                  cause_category_code: '1',
                  cause_category_name: 'Equipment',
                  cause_cause_code: '2',
                  cause_cause_name: 'Outdated Equipment',
              },
          } } }

          it { is_expected.to eq true }

          it 'assigns the products' do
            expect{
              form.save
            }.to change{ defect.possible_causes.count }.from(0).to 1

            expect( defect.possible_causes[0]&.cause_category_code ).to eq 1
            expect( defect.possible_causes[0]&.cause_category_name ).to eq 'Equipment'
            expect( defect.possible_causes[0]&.cause_cause_code ).to eq 2
            expect( defect.possible_causes[0]&.cause_cause_name ).to eq 'Outdated Equipment'
          end
        end
      end

    end
  end
end
