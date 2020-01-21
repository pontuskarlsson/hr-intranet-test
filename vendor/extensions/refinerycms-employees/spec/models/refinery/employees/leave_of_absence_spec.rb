require 'spec_helper'

module Refinery
  module Employees
    describe LeaveOfAbsence do
      describe 'validations' do
        let(:leave_of_absence) { FactoryBot.build(:leave_of_absence) }
        subject { leave_of_absence }

        it { is_expected.to be_valid }

        context 'when employee is missing' do
          before { leave_of_absence.employee = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when start_date is missing' do
          before { leave_of_absence.start_date = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when end_date is prior to start_date' do
          before { leave_of_absence.end_date = leave_of_absence.start_date - 1.day }
          it { is_expected.not_to be_valid }
        end
      end

      describe 'on create' do
        before { leave_of_absence }

        context 'when it only has a start date but no end date' do
          let(:leave_of_absence) { FactoryBot.create(:leave_of_absence, start_date: '2014-12-12') }

          it {
            expect(leave_of_absence.event).to be_persisted
            expect(leave_of_absence.event.starts_at.to_date).to eq leave_of_absence.start_date
            expect(leave_of_absence.event.ends_at).to be_nil
          }
        end

        context 'when it has both a start date and an end date' do
          let(:leave_of_absence) { FactoryBot.create(:leave_of_absence, start_date: '2014-12-12', end_date: '2014-12-19') }

          it {
            expect(leave_of_absence.event).to be_persisted
            expect(leave_of_absence.event.starts_at.to_date).to eq leave_of_absence.start_date
            expect(leave_of_absence.event.ends_at.to_date).to eq leave_of_absence.end_date
          }
        end
      end

      describe 'on update' do
        context 'when end date was removed' do
          let(:leave_of_absence) { FactoryBot.create(:leave_of_absence, start_date: '2014-12-12', end_date: '2014-12-19') }
          before { leave_of_absence.update_attributes(end_date: nil) }

          it { expect(leave_of_absence.event.reload.ends_at).to be_nil }
        end
      end
    end
  end
end
