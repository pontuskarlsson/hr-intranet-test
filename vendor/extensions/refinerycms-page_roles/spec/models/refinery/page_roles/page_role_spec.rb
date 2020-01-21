require 'spec_helper'

module Refinery
  module PageRoles
    describe PageRole do
      describe "validations" do
        subject do
          FactoryBot.create(:page_role)
        end

        it { should be_valid }
        its(:errors) { should be_empty }
      end
    end
  end
end
