require 'rails_helper'

describe ExpenseClaimsController do
  render_views
  login_user

  let(:expense_claim) { FactoryGirl.create(:expense_claim, user: current_user) }
  let(:other_expense_claim) { FactoryGirl.create(:expense_claim) }

  describe "GET 'new'" do
    it 'shows the view to create a new expense claim' do
      get 'new'
      expect( response ).to be_success
    end
  end

  describe "POST 'create'" do
    it 'creates a new expense claim for the current user' do
      attr = { description: 'Newly created Expense Claim' }

      count = current_user.expense_claims.count

      post 'create', expense_claim: attr
      expect( response ).to be_redirect
      expect( current_user.expense_claims.count ).to eq count+1
    end
  end

  describe "GET 'show'" do
    it 'shows the details of an expense claim' do
      expect( expense_claim.user ).to eq current_user

      get 'show', id: expense_claim.to_param
      expect( response ).to be_success
    end

    it 'cannot show the details of another users expense claim' do
      expect( other_expense_claim.user ).not_to eq current_user

      get 'show', id: other_expense_claim.to_param
      expect( response ).to be_redirect
    end
  end

  describe "DELETE 'destroy'" do
    let(:submitted_expense_claim) { FactoryGirl.create(:expense_claim, status: ExpenseClaim::STATUS_SUBMITTED) }
    it 'can remove a non-submitted expense claim' do
      expect( expense_claim.status ).to eq ExpenseClaim::STATUS_NOT_SUBMITTED

      delete 'destroy', id: expense_claim.to_param
      expect( response.redirect_url ).not_to include "/expense_claims/#{ submitted_expense_claim.to_param }"
      expect( ExpenseClaim.find_by_id(expense_claim.id) ).to be_nil
    end

    it 'cannot remove a submitted expense claim' do
      expect( submitted_expense_claim.status ).to eq ExpenseClaim::STATUS_SUBMITTED

      delete 'destroy', id: submitted_expense_claim.to_param
      expect( response.redirect_url ).to include "/expense_claims/#{ submitted_expense_claim.to_param }"
      expect( ExpenseClaim.find_by_id(submitted_expense_claim.id) ).to be_present
    end
  end

end
