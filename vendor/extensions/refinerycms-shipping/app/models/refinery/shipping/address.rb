module Refinery
  module Shipping
    class Address < Refinery::Core::BaseModel
      self.table_name = 'refinery_shipping_addresses'

      validates :easy_post_id,  uniqueness: true, allow_blank: true

      #attr_accessible :name, :street1, :street2, :city, :zip, :state, :country, :phone, :email

      def assign_from_contact(contact)
        org = contact.organisation

        self.name     = contact.name
        self.street1  = contact.address.present?  ? contact.address : org.try(:address)
        self.state    = contact.state.present?    ? contact.state   : org.try(:state)
        self.zip      = contact.zip.present?      ? contact.zip     : org.try(:zip)
        self.city     = contact.city.present?     ? contact.city    : org.try(:city)
        self.country  = contact.country.present?  ? contact.country : org.try(:country)
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

      def present_address_lines
        [street1, street2, city, zip, state, country].reject(&:blank?)
      end

      def google_maps_url
        if present_address_lines.any?
          "http://maps.google.com/?q=#{ present_address_lines.join(',') }"
        end
      end

    end
  end
end
