module Refinery
  module Parcels
    module ShipmentsHelper

      def contact_references
        @_contact_references ||= ::Refinery::Marketing::Contact.select(:name).map(&:name).compact.to_json
      end

    end
  end
end
