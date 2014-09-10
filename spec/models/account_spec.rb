require 'rails_helper'

RSpec.describe Account do
  describe 'validations' do
    let(:account) { FactoryGirl.build(:account) }
    it 'validates guid presence' do
      expect( account ).to be_valid

      account.guid = nil
      expect( account ).to be_invalid
    end
    it 'validates guid uniqueness' do
      expect( account ).to be_valid

      FactoryGirl.create(:account, guid: account.guid)
      expect( account ).to be_invalid
    end
    it 'validates code presence' do
      expect( account ).to be_valid

      account.code = nil
      expect( account ).to be_invalid
    end
    it 'validates code uniqueness' do
      expect( account ).to be_valid

      FactoryGirl.create(:account, code: account.code)
      expect( account ).to be_invalid
    end

    it 'validates name presence' do
      expect( account ).to be_valid

      account.name = ''
      expect( account ).to be_invalid
    end
  end
end
