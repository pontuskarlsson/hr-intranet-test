module Refinery
  module Parcels
    class ShipmentAddress < Refinery::Core::BaseModel
      self.table_name = 'refinery_parcels_shipment_addresses'

      validates :name,          presence: true
      validates :easy_post_id,  uniqueness: true, allow_blank: true

      attr_accessible :name, :street1, :street2, :city, :zip, :state, :country, :phone, :email

      def assign_from_contact(contact)
        self.name     = contact.name
        self.street1  = contact.address
        #self.state    = contact.state     # Contact does not have state information...
        self.zip      = contact.zip
        self.city     = contact.city
        self.country  = contact.country
        self.phone    = [contact.phone, contact.mobile].reject(&:blank?).first
        self.email    = contact.email
        self.company  = contact.organisation_name
      end

      def missing_for_shipment
        %w(name street1 city country phone).map { |attr|
          if send(attr).blank?
            "#{attr} is missing"
          end
        }.compact
      end

    end
  end
end
