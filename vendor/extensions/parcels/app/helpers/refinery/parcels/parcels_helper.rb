module Refinery
  module Parcels
    module ParcelsHelper

      def user_references
        @_user_references ||= ::Refinery::User.select(::Refinery::Parcels.config.user_attribute_reference).map(&:"#{::Refinery::Parcels.config.user_attribute_reference}").compact.to_json
      end

      def contact_references
        @_contact_references ||= ::Refinery::Marketing::Contact.select(:name).map(&:name).compact.to_json
      end

    end
  end
end
