module Refinery
  module Shipping
    class Location < Refinery::Core::BaseModel
      self.table_name = 'refinery_shipping_locations'

      TYPES = %w(port warehouse)

      belongs_to :owner,          class_name: '::Refinery::Business::Company'

      configure_assign_by_label :owner, class_name: '::Refinery::Business::Company'

      validates :name,            presence: true, uniqueness: { scope: :owner_id }

      validate do
        if verified_at.present?
          errors.add(:address_id, :missing) unless address.present?
        end
      end

      scope :is_public, -> { where(public: true) }

      def self.to_source
        where(nil).to_json(methods: [:value, :label]).html_safe
      end

      def self.find_by_label(label)
        find_by_name label
      end

      def value
        name
      end

      def label
        name
      end

    end
  end
end
