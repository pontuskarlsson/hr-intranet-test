require 'spec_helper'

module Refinery
  module Calendar
    describe GoogleEvent do
      # Simulates a successful save to the Google API
      before { allow_any_instance_of(::Google::Event).to receive(:save) { true } }

      describe 'validations' do
        let(:google_event) { FactoryGirl.build(:google_event) }
        subject { google_event }

        it { is_expected.to be_valid }

        context 'when google_calendar is missing' do
          before { google_event.google_calendar = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when event is missing' do
          before { google_event.event = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when google_calendar and event is already present' do
          before { FactoryGirl.create(:google_event, google_calendar: google_event.google_calendar, event: google_event.event) }
          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
