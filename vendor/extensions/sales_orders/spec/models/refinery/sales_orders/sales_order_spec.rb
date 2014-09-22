require 'spec_helper'

module Refinery
  module SalesOrders
    describe SalesOrder do
      describe "validations" do
        subject do
          FactoryGirl.create(:sales_order,
          :order_id => "Refinery CMS")
        end

        it { should be_valid }
        its(:errors) { should be_empty }
        its(:order_id) { should == "Refinery CMS" }
      end
    end
  end
end
