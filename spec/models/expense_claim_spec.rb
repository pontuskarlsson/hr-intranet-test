require 'rails_helper'

describe ExpenseClaim do
  describe 'validations' do
    let(:expense_claim) { FactoryGirl.build(:expense_claim) }
    it 'validates user presence' do
      expect( expense_claim ).to be_valid

      expense_claim.user = nil
      expect( expense_claim ).to be_invalid
    end
    it 'validates description presence' do
      expect( expense_claim ).to be_valid

      expense_claim.description = ''
      expect( expense_claim ).to be_invalid
    end
    it 'status inclusion' do
      expect( ExpenseClaim::STATUSES ).to include expense_claim.status
      expect( expense_claim ).to be_valid

      expense_claim.status = 'Not-a-valid-status'
      expect( ExpenseClaim::STATUSES ).not_to include expense_claim.status
      expect( expense_claim ).to be_invalid
    end
  end
end
