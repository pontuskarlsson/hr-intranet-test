require 'rails_helper'

describe Receipt do
  describe 'validations' do
    let(:receipt) { FactoryGirl.build(:receipt) }
    it 'validates expense_claim presence' do
      expect( receipt ).to be_valid

      receipt.expense_claim = nil
      expect( receipt ).to be_invalid
    end
    it 'validates contact presence' do
      expect( receipt ).to be_valid

      receipt.contact = nil
      expect( receipt ).to be_invalid
    end
    it 'validates that total is bigger than 0' do
      expect( receipt ).to be_valid

      receipt.total = -1
      expect( receipt ).to be_invalid

      receipt.total = 0
      expect( receipt ).to be_invalid

      receipt.total = 1
      expect( receipt ).to be_valid
    end
    it 'status inclusion' do
      expect( Receipt::STATUSES ).to include receipt.status
      expect( receipt ).to be_valid

      receipt.status = 'Not-a-valid-status'
      expect( Receipt::STATUSES ).not_to include receipt.status
      expect( receipt ).to be_invalid
    end
  end
end
