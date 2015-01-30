module Refinery
  module Parcels
    class Shipment < Refinery::Core::BaseModel
      COURIERS = ['SF Express', 'UPS', 'DHL']

      self.table_name = 'refinery_parcels_shipments'

      belongs_to :from_contact,       class_name: '::Refinery::Marketing::Contact'
      belongs_to :from_address,       class_name: '::Refinery::Parcels::ShipmentAddress'
      belongs_to :to_contact,         class_name: '::Refinery::Marketing::Contact'
      belongs_to :to_address,         class_name: '::Refinery::Parcels::ShipmentAddress'
      belongs_to :created_by,         class_name: '::Refinery::User'
      belongs_to :assigned_to,        class_name: '::Refinery::User'
      has_many :shipment_parcels,     dependent: :destroy
      has_many :shipment_customs_info

      attr_writer :from_contact_name, :to_contact_name, :assign_to

      attr_accessible :from_contact_name, :to_contact_name, :courier, :assign_to

      validates :created_by_id,   presence: true
      validates :assigned_to_id,  presence: true
      validates :courier,         inclusion: COURIERS

      delegate :name, to: :from_contact,  prefix: true, allow_nil: true
      delegate :name, to: :to_contact,    prefix: true, allow_nil: true

      before_validation do
        # Makes sure there is always address object present to assign values to.
        self.from_address ||= ShipmentAddress.new
        self.to_address ||= ShipmentAddress.new

        # Try to find a contact to assign address values from
        if @from_contact_name.present?
          if (contact = ::Refinery::Marketing::Contact.find_by_name(@from_contact_name)).present?
            self.from_contact = contact
            from_address.assign_from_contact(contact)
          else
            from_address.name = @from_contact_name
          end
        end

        # Try to find a contact to assign address values from
        if @to_contact_name.present?
          if (contact = ::Refinery::Marketing::Contact.find_by_name(@to_contact_name)).present?
            self.to_contact = contact
            to_address.assign_from_contact(contact)
          else
            to_address.name = @to_contact_name
          end
        end

        # Try to find a user to assign the shipment to
        if @assign_to.present?
          self.assigned_to = ::Refinery::User.send("find_by_#{ Refinery::Parcels.config.user_attribute_reference }", @assign_to)
        end
        self.assigned_to ||= created_by
      end

      def assign_to
        @to ||= assigned_to.try(:"#{ Refinery::Parcels.config.user_attribute_reference }")
      end

      # Method used to check whether a particular user has the right to update the
      # shipment information. This is only used by the front-end controller, not the
      # admin controller.
      def editable_by?(user)
        return false unless user.present?

        created_by_id == user.id || assigned_to_id == user.id
      end

      def courier_predefined_packages
        ShipmentParcel::PREDEFINED_PACKAGES[courier] || []
      end

    end
  end
end
