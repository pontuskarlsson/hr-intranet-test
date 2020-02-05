# frozen_string_literal: true

require 'spec_helper'

module Refinery
  describe Resource, type: :model do
    let(:resource) { FactoryBot.create(:resource) }

    context 'with valid attributes' do
      it 'should assign file_mime_type' do
        expect(resource.file_mime_type).to be_present
      end
    end

    describe '#mime_type' do
      before { resource } # Make sure it is created first

      context 'when file_mime_type is present on model' do
        it 'should have a file_mime_type present' do
          expect(resource.file_mime_type).to be_present
        end

        it 'should return file_mime_type when called' do
          expect(resource.mime_type).to eq resource.file_mime_type
        end

        it 'should not resort to ask datastore for mime_type' do
          expect(resource.file).not_to receive(:mime_type)
          resource.mime_type
        end
      end

      context 'when file_mime_type is not_present on model' do
        before { resource.file_mime_type = nil; resource.save }

        it 'should have a file_mime_type present' do
          expect(resource.file_mime_type).not_to be_present
        end

        it 'should still return a mime_type' do
          expect(resource.mime_type).to be_present
        end

        it 'should resort to ask datastore for mime_type' do
          expect(resource.file).to receive(:mime_type)
          resource.mime_type
        end
      end
    end
  end
end
