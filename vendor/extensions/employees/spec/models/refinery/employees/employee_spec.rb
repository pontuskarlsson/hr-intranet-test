require 'spec_helper'

module Refinery
  module Employees
    describe Employee do
      describe "validations" do
        subject do
          FactoryGirl.create(:employee,
          :employee_no => "Refinery CMS")
        end

        it { should be_valid }
        its(:errors) { should be_empty }
        its(:employee_no) { should == "Refinery CMS" }
      end
    end
  end
end
