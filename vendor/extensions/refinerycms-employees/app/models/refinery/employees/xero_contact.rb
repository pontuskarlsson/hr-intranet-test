module Refinery
  module Employees
    class XeroContact < Refinery::Core::BaseModel
      self.table_name = 'refinery_xero_contacts'

      has_many :xero_receipts, dependent: :nullify

      attr_accessible :guid, :name

      validates :guid,    uniqueness: true, allow_blank: true
      validates :name,    presence: true, uniqueness: { scope: :inactive }, unless: :inactive

    end
  end
end
