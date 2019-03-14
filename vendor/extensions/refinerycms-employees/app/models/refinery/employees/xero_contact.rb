module Refinery
  module Employees
    class XeroContact < Refinery::Core::BaseModel
      self.table_name = 'refinery_xero_contacts'

      has_many :xero_receipts, dependent: :nullify

      #attr_accessible :guid, :name

      validates :guid,    uniqueness: true, allow_blank: true
      validates :name,    presence: true, uniqueness: { scope: :inactive }, unless: :inactive


      class << self

        def sync_from_xero!(contact)
          xero_contact = find_or_initialize_by_guid(contact.contact_id)
          contact.attributes.each_pair do |attr, value|
            xero_contact.send("#{attr}=", value) if xero_contact.respond_to?("#{attr}=")
          end
          xero_contact.save!
        end

      end
    end
  end
end
