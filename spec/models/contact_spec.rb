require 'rails_helper'

RSpec.describe Contact do
  describe 'validations' do
    let(:contact) { FactoryGirl.build(:contact) }
    it 'allows guid to be blank' do
      expect( contact ).to be_valid

      contact.guid = ''
      expect( contact ).to be_valid
    end
    it 'validates guid uniqueness if present' do
      expect( contact.guid ).to be_present
      expect( contact ).to be_valid

      FactoryGirl.create(:contact, guid: contact.guid)
      expect( contact ).to be_invalid
    end
    it 'validates name presence' do
      expect( contact ).to be_valid

      contact.name = ''
      expect( contact ).to be_invalid
    end
    it 'validates name uniqueness' do
      expect( contact ).to be_valid

      FactoryGirl.create(:contact, name: contact.name)
      expect( contact ).to be_invalid
    end
  end
end
