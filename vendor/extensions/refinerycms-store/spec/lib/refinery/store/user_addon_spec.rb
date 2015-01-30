require 'spec_helper'

module Refinery
  module Store
    describe "UserAddon" do
      it 'extends Refinery::User model with methods' do
        expect( ::Refinery::User.new ).to respond_to(:cart_count)
      end
    end
  end
end
