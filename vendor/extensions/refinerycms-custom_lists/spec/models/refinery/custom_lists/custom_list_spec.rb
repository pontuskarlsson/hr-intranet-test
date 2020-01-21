require 'spec_helper'

module Refinery
  module CustomLists
    describe CustomList do
      describe "validations" do
        subject do
          FactoryBot.create(:custom_list,
          :title => "Refinery CMS")
        end

        it { should be_valid }
        its(:errors) { should be_empty }
        its(:title) { should == "Refinery CMS" }
      end
    end
  end
end
