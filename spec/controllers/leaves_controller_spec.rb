require 'rails_helper'

RSpec.describe LeavesController do
  render_views
  login_user

  let(:leave) { FactoryGirl.create(:leave, user: current_user) }

  describe "GET 'new'" do
    it 'shows the view to create a new leave' do
      get 'new'
      expect( response ).to be_success
    end
  end

  describe "POST 'create'" do
    it 'creates a new leave as well as an associated event for the current user' do
      attr = { starts_at: DateTime.now + 1, ends_at: DateTime.now + 2, comment: 'Vacation!!' }

      count = current_user.leaves.count

      post 'create', leave: attr
      expect( response ).to be_redirect
      expect( current_user.leaves.count ).to eq count+1
      leave = current_user.leaves.last
      event = leave.event
      expect( event ).to be_present
      expect( event.starts_at ).to eq leave.starts_at
      expect( event.ends_at ).to eq leave.ends_at
    end
  end
end
