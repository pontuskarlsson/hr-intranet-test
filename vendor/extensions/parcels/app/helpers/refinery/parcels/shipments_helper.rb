module Refinery
  module Parcels
    module ShipmentsHelper

      def contact_references
        @_contact_references ||= ::Refinery::Marketing::Contact.includes(:organisation).map { |contact|
          {
              value: contact.id,
              label: contact.name,
              organisation_name: contact.organisation.try(:organisation_name),
              address: contact.address.blank? ? contact.organisation.try(:address) : contact.address
          }
        }.to_json
      end

    end
  end
end
