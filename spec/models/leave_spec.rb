require 'rails_helper'

RSpec.describe Leave do
  describe 'validations' do
    let(:leave) { FactoryGirl.build(:leave) }
    it 'validates starts_at presence' do
      expect( leave ).to be_valid

      leave.starts_at = nil
      expect( leave ).to be_invalid
    end
    it 'validates ends_at presence' do
      expect( leave ).to be_valid

      leave.ends_at = nil
      expect( leave ).to be_invalid
    end
    it 'validates user presence' do
      expect( leave ).to be_valid

      leave.user = nil
      expect( leave ).to be_invalid
    end
    it 'validates that ends_at is later than starts_at' do
      expect( leave ).to be_valid

      leave.ends_at = leave.starts_at - 1.day
      expect( leave ).to be_invalid
    end
  end
end
