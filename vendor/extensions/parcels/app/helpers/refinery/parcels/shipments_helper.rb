module Refinery
  module Parcels
    module ShipmentsHelper

      def contact_references
        @_contact_references ||= ::Refinery::Marketing::Contact.select([:id, :name, :organisation_name, :address]).map { |contact|
          { value: contact.id, label: contact.name, organisation_name: contact.organisation_name, address: contact.address }
        }.to_json
      end

    end
  end
end
