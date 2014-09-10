require 'rails_helper'

describe ReceiptsController do
  render_views
  login_user

  let(:expense_claim) { FactoryGirl.create(:expense_claim, user: current_user) }

  describe "GET 'new'" do
    it 'shows the view to create a new receipt' do
      get 'new', expense_claim_id: expense_claim.to_param
      expect( response ).to be_success
    end
  end

  describe "POST 'create'" do
    let(:account) { FactoryGirl.create(:account) }
    let(:contact) { FactoryGirl.create(:contact) }
    it 'creates a new receipt for an existing expense_claim' do
      attr = { contact_id: contact.id, date: '2014-01-01', line_items_attributes: {
          '0' => { description: 'Coffee, black', quantity: '1', unit_amount: '21.5', account_id: account.id }
      } }

      count = expense_claim.receipts.count

      post 'create', expense_claim_id: expense_claim.to_param, receipt: attr
      expect( response ).to be_redirect
      expect( expense_claim.receipts.count ).to eq count+1
      expect( expense_claim.receipts.first.line_items.count ).to eq attr[:line_items_attributes].keys.count
    end
  end

end
