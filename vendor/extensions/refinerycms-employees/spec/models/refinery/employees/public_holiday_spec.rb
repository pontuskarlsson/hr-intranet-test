require 'spec_helper'

module Refinery
  module Employees
    describe PublicHoliday do
      describe "validations" do
        let(:public_holiday) { FactoryGirl.build(:public_holiday) }

        it 'validates title presence' do
          expect(public_holiday).to be_valid

          public_holiday.title = ''
          expect(public_holiday).not_to be_valid
        end
        it 'validates holiday_date presence' do
          expect(public_holiday).to be_valid

          public_holiday.holiday_date = nil
          expect(public_holiday).not_to be_valid
        end
        it 'validates country inclusion' do
          expect(public_holiday).to be_valid

          public_holiday.country = 'random string'
          expect(public_holiday).not_to be_valid
        end
        it 'validates holiday_date and country uniqueness' do
          expect(public_holiday).to be_valid

          FactoryGirl.create(:public_holiday, holiday_date: public_holiday.holiday_date, country: public_holiday.country)
          expect(public_holiday).not_to be_valid
        end
        it 'validates event_id uniqueness if present' do
          expect(public_holiday).to be_valid

          public_holiday.event_id = FactoryGirl.create(:public_holiday).event_id
          expect(public_holiday).not_to be_valid
        end
      end
    end
  end
end
