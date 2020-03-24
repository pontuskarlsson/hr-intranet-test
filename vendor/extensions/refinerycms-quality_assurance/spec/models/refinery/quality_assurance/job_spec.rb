require 'spec_helper'

module Refinery
  module QualityAssurance
    describe Job do
      describe 'validations' do
        let(:job) { FactoryBot.build(:job) }
        subject { job }

        it { is_expected.to be_valid }

        context 'when :project is from another Company' do
          before { job.project = FactoryBot.create(:project) }
          it { is_expected.not_to be_valid }
        end

        context 'when :project is from the same Company' do
          before { job.project = FactoryBot.create(:project, company: job.company) }
          it { is_expected.to be_valid }
        end
      end
    end
  end
end
