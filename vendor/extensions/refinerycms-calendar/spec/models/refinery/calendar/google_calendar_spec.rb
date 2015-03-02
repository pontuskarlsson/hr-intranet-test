require 'spec_helper'

module Refinery
  module Calendar
    describe GoogleCalendar do
      describe 'validations' do
        let(:google_calendar) { FactoryGirl.build(:google_calendar) }
        subject { google_calendar }

        it { is_expected.to be_valid }

        context 'when google_calendar_id is missing' do
          before { google_calendar.google_calendar_id = '' }
          it { is_expected.not_to be_valid }
        end

        context 'when google_calendar_id is already present' do
          before { FactoryGirl.create(:google_calendar, google_calendar_id: google_calendar.google_calendar_id) }
          it { is_expected.not_to be_valid }
        end

        context 'when primary_calendar is missing' do
          before { google_calendar.primary_calendar = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when primary_calendar is already present' do
          before { FactoryGirl.create(:google_calendar, primary_calendar: google_calendar.primary_calendar) }
          it { is_expected.not_to be_valid }
        end

        context 'when user is missing' do
          before { google_calendar.user = nil }
          it { is_expected.not_to be_valid }
        end
      end

      describe '#before_save' do
        let(:google_calendar) { FactoryGirl.create(:google_calendar) }
        subject { google_calendar }

        context 'when updating google calendar id' do
          let(:google_calendar) { FactoryGirl.create(:google_calendar_with_refresh_token) }
          before { google_calendar.update_attributes(google_calendar_id: 'abcdefg012345') }
          it 'clears the refresh token' do
            expect( google_calendar.refresh_token ).to be_blank
          end
        end
      end
    end
  end
end
