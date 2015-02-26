require 'spec_helper'

module Refinery
  module Calendar
    describe UserCalendar do
      describe 'validations' do
        let(:user_calendar) { FactoryGirl.build(:user_calendar) }
        subject { user_calendar }

        it { is_expected.to be_valid }

        context 'when user is missing' do
          before { user_calendar.user = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when calendar is missing' do
          before { user_calendar.calendar = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when user and calendar is already present' do
          before { FactoryGirl.create(:user_calendar, user: user_calendar.user, calendar: user_calendar.calendar) }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
