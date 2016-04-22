module Refinery
  module Parcels
    module ShipmentsHelper

      def contact_references
        @_contact_references ||= ::Refinery::Marketing::Contact.includes(:organisation).select([:id, :name, :organisation_name, :address]).map { |contact|
          organisation_name = contact.organisation_name.blank? ? contact.organisation.try(:name) : contact.organisation_name
          { value: contact.id, label: contact.name, organisation_name: organisation_name, address: contact.address }
        }.to_json
      end

    end
  end
end
