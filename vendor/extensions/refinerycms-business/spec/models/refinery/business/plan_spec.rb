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

      end
    end
  end
end
