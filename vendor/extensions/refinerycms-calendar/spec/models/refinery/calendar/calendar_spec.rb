require 'spec_helper'

module Refinery
  module Calendar
    describe Calendar do
      describe 'validations' do
        let(:calendar) { FactoryGirl.build(:calendar) }
        subject { calendar }

        it { is_expected.to be_valid }

        context 'when title is missing' do
          before { calendar.title = '' }
          it { is_expected.not_to be_valid }
        end

        context 'when title and user is already present' do
          before { FactoryGirl.create(:calendar, user: calendar.user, title: calendar.title) }
          it { is_expected.not_to be_valid }
        end

        context 'when function is already present' do
          let(:calendar) { FactoryGirl.build(:calendar, function: 'Holidays') }
          before { FactoryGirl.create(:calendar, function: calendar.function) }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
