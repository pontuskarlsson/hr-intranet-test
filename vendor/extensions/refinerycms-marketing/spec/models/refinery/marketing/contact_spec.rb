require 'spec_helper'

module Refinery
  module Marketing
    describe Contact do
      describe 'validations' do
        let(:contact) { FactoryGirl.build(:contact) }

        it 'validates base_id presence' do
          expect(contact).to be_valid

          contact.base_id = nil
          expect(contact).not_to be_valid
        end
      end
    end
  end
end
