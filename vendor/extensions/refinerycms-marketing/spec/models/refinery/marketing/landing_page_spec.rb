require 'spec_helper'

module Refinery
  module Marketing
    describe LandingPage do
      describe 'validations' do
        let(:landing_page) { FactoryBot.build(:landing_page) }
        subject { landing_page }

        it { is_expected.to be_valid }

        context 'when :title is missing' do
          before { landing_page.title = nil }

          it { is_expected.not_to be_valid }
        end
      end

      describe '#save' do
        let(:landing_page) { FactoryBot.build(:landing_page) }
        subject { landing_page.save }

        context 'when a new LandingPage is created' do
          it 'creates a new LandingPage' do
            expect{
              landing_page.save
            }.to change{ Refinery::Marketing::LandingPage.count }.by 1
          end

          it 'creates a Page and assigns to landing_page' do
            expect{
              landing_page.save
            }.to change{ Refinery::Page.count }.by 1

            expect( landing_page.page ).to be_present
          end
        end
      end
    end
  end
end
