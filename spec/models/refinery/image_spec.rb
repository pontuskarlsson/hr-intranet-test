# frozen_string_literal: true

require 'spec_helper'

module Refinery
  describe Image, type: :model do
    let(:image) { FactoryBot.create(:image) }

    context 'with valid attributes' do
      it 'should assign image_mime_type' do
        expect(image.image_mime_type).to be_present
      end
    end

    describe '#mime_type' do
      before { image } # Make sure it is created first

      context 'when image_mime_type is present on model' do
        it 'should have a image_mime_type present' do
          expect(image.image_mime_type).to be_present
        end

        it 'should return image_mime_type when called' do
          expect(image.mime_type).to eq image.image_mime_type
        end

        it 'should not resort to ask datastore for mime_type' do
          expect(image.image).not_to receive(:mime_type)
          image.mime_type
        end
      end

      context 'when image_mime_type is not_present on model' do
        before { image.image_mime_type = nil; image.save }

        it 'should have a image_mime_type present' do
          expect(image.image_mime_type).not_to be_present
        end

        it 'should still return a mime_type' do
          expect(image.mime_type).to be_present
        end

        it 'should resort to ask datastore for mime_type' do
          expect(image.image).to receive(:mime_type)
          image.mime_type
        end
      end
    end
  end
end
