require 'spec_helper'

module Refinery
  module Business
    describe Article do
      describe 'validations' do
        let(:article) { FactoryBot.build(:article) }
        subject { article }

        it { is_expected.to be_valid }

        context 'when :code is missing' do
          before { article.code = nil }
          it { is_expected.not_to be_valid }
        end

        context 'when :code is already present' do
          before { FactoryBot.create(:article, code: article.code) }
          it { is_expected.not_to be_valid }
        end

        context 'when :is_public is true and :company is missing' do
          before { article.is_public = true; article.company = nil }
          it { is_expected.to be_valid }
        end

        context 'when :is_public is false and :company is missing' do
          before { article.is_public = false; article.company = nil }
          it { is_expected.to be_valid }
        end

        context 'when :is_public is false and :company is present' do
          before { article.is_public = false; article.company = FactoryBot.create(:company) }
          it { is_expected.to be_valid }
        end

        context 'when :is_public is true and :company is present' do
          before { article.is_public = true; article.company = FactoryBot.create(:company) }
          it { is_expected.not_to be_valid }
        end

      end
    end
  end
end
