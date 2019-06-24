module Refinery
  module Shipping
    module ParcelsHelper

      def user_references
        @_user_references ||= ::Refinery::Authentication::Devise::User.pluck(:full_name).compact.to_json
      end

      def contact_references
        @_contact_references ||= ::Refinery::Marketing::Contact.pluck(:name).compact.to_json
      end

    end
  end
end
