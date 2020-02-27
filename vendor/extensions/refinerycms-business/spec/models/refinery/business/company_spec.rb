require 'spec_helper'

module Refinery
  module Business
    describe Company do
      describe 'validations' do
        let(:company) { FactoryBot.build(:company) }
        subject { company }

        it { is_expected.to be_valid }

        context 'when :name is missing' do
          before { company.name = nil }

          it { is_expected.not_to be_valid }
        end

        context 'when :code is missing' do
          before { company.code = nil }

          it { is_expected.to be_valid }
        end
      end

      describe '#save' do
        let(:company) { FactoryBot.build(:company) }

        context 'when verified_at and code is not present' do
          before {
            company.code = nil
            company.verified_at = nil
          }

          it 'does not assign a new code' do
            expect{
              company.save
            }.not_to change{ company.code }.from nil
          end
        end

        context 'when verified_at is present but code is blank' do
          before {
            company.code = nil
            company.verified_at = DateTime.now
          }

          it 'does assign a new code' do
            expect{
              company.save
            }.to change{ company.code }.from nil
          end
        end
      end
    end
  end
end
