# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Store" do
    describe "carts" do
      refinery_login_with_devise :refinery_user

      describe "shopping cart list" do

        it "shows an empty shopping cart if no products are selected" do
          visit refinery.store_cart_path
          page.should have_content("My Cart")
        end

      end
    end
  end
end
