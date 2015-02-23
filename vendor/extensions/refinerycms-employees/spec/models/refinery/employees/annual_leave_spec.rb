require 'spec_helper'

module Refinery
  module Employees
    describe AnnualLeave do
      describe 'validations' do
        let(:annual_leave) { FactoryGirl.build(:annual_leave) }
        subject { annual_leave }

        it { is_expected.to be_valid }

        context 'when employee is missing' do
          before { annual_leave.employee = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when start_date is missing' do
          before { annual_leave.start_date = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when end_date is prior to start_date' do
          before { annual_leave.end_date = annual_leave.start_date - 1.day }
          it { is_expected.not_to be_valid }
        end
      end

      describe 'on create' do
        before { annual_leave }

        context 'when it only has a start date but no end date' do
          let(:annual_leave) { FactoryGirl.create(:annual_leave, start_date: '2014-12-12') }

          it {
            expect(annual_leave.event).to be_persisted
            expect(annual_leave.event.starts_at.to_date).to eq annual_leave.start_date
            expect(annual_leave.event.ends_at).to be_nil
          }
        end

        context 'when it has both a start date and an end date' do
          let(:annual_leave) { FactoryGirl.create(:annual_leave, start_date: '2014-12-12', end_date: '2014-12-19') }

          it {
            expect(annual_leave.event).to be_persisted
            expect(annual_leave.event.starts_at.to_date).to eq annual_leave.start_date
            expect(annual_leave.event.ends_at.to_date).to eq annual_leave.end_date
          }
        end
      end

      describe 'on update' do
        context 'when end date was removed' do
          let(:annual_leave) { FactoryGirl.create(:annual_leave, start_date: '2014-12-12', end_date: '2014-12-19') }
          before { annual_leave.update_attributes(end_date: nil) }

          it { expect(annual_leave.event.ends_at).to be_nil }
        end
      end
    end
  end
end
