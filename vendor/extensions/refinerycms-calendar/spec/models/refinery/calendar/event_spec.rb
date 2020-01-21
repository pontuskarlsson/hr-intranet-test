require 'spec_helper'

module Refinery
  module Calendar
    describe Event do
      describe 'validations' do
        let(:event) { FactoryBot.build(:event) }
        subject { event }

        it { is_expected.to be_valid }

        context 'when title is missing' do
          before { event.title = '' }
          it { is_expected.not_to be_valid }
        end

        context 'when Calendar is missing' do
          before { event.calendar = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when starts_at is missing' do
          before { event.starts_at = nil }
          it { is_expected.not_to be_valid }
        end
      end

      describe 'upcoming events' do
        before :each do
          FactoryBot.create(:event, starts_at: 2.hours.ago)
          FactoryBot.create(:event, starts_at: 2.hours.from_now)
          FactoryBot.create(:event, starts_at: 2.days.from_now)
          FactoryBot.create(:event, starts_at: 2.weeks.from_now)
        end

        it 'only includes upcoming event' do
          expect( Event.upcoming.count ).to eq 3
        end
      end

      describe 'tomorrow events' do
        before :each do
          FactoryBot.create(:event, starts_at: Date.tomorrow - 2.hours)
          FactoryBot.create(:event, starts_at: Date.tomorrow.beginning_of_day)
          FactoryBot.create(:event, starts_at: Date.tomorrow + 2.hours)
          FactoryBot.create(:event, starts_at: Date.tomorrow + 6.hours)
          FactoryBot.create(:event, starts_at: Date.tomorrow + 12.hours)
          FactoryBot.create(:event, starts_at: Date.yesterday, ends_at: 2.days.from_now)
          FactoryBot.create(:event, starts_at: Date.tomorrow + 2.days)
        end

        it 'only includes events for tomorrow' do
          expect( Event.on_day(Date.tomorrow).count ).to eq 5
        end
      end

    end
  end
end
