# require 'spec_helper'
#
# module Refinery
#   module Shipping
#     describe Parcel do
#       describe 'validations' do
#         let(:parcel) { FactoryBot.build(:parcel) }
#         subject { parcel }
#
#         it { is_expected.to be_valid }
#
#         context 'when :received_by is missing' do
#           before { parcel.received_by = nil }
#           it { is_expected.not_to be_valid }
#         end
#       end
#     end
#   end
# end
