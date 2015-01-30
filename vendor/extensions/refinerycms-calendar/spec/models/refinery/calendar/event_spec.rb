require 'spec_helper'

module Refinery
  module Calendar
    describe Event do
      describe "validations" do
        let(:event) { FactoryGirl.build(:event) }
        it 'validates title presence' do
          expect( event ).to be_valid

          event.title = ''
          expect( event ).to_not be_valid
        end
      end

      describe "upcoming events" do

        before :each do
          FactoryGirl.create(:event, starts_at: 2.hours.ago)
          FactoryGirl.create(:event, starts_at: 2.hours.from_now)
          FactoryGirl.create(:event, starts_at: 2.days.from_now)
          FactoryGirl.create(:event, starts_at: 2.weeks.from_now)
        end

        it "only includes upcoming event" do
          expect( Event.upcoming.count ).to eq 3
        end
      end

      describe "tomorrow events" do
        before :each do
          FactoryGirl.create(:event, starts_at: Date.tomorrow - 2.hours)
          FactoryGirl.create(:event, starts_at: Date.tomorrow.beginning_of_day)
          FactoryGirl.create(:event, starts_at: Date.tomorrow + 2.hours)
          FactoryGirl.create(:event, starts_at: Date.tomorrow + 6.hours)
          FactoryGirl.create(:event, starts_at: Date.tomorrow + 12.hours)
          FactoryGirl.create(:event, starts_at: Date.yesterday, ends_at: 2.days.from_now)
          FactoryGirl.create(:event, starts_at: Date.tomorrow + 2.days)
        end

        it "only includes events for tomorrow" do
          expect( Event.on_day(Date.tomorrow).count ).to eq 5
        end
      end

    end
  end
end
