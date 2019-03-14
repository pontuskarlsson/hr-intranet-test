module Refinery
  module Parcels
    class Shipment < Refinery::Core::BaseModel

      COURIER_SF = 'SF'
      COURIER_FEDEX = 'Fedex'
      COURIER_UPS = 'UPS'
      COURIER_DHL = 'DHLExpress'

      COURIERS = { COURIER_SF    => { easypost: false,
                                      parcels: %w() },
                   COURIER_FEDEX => { easypost: false,
                                      parcels: %w() },
                   COURIER_UPS   => { easypost: true,
                                      parcels: %w(UPSLetter UPSExpressBox UPS25kgBox UPS10kgBox Tube Pak Pallet SmallExpressBox MediumExpressBox LargeExpressBox) },
                   COURIER_DHL   => { easypost: true,
                                      service: 'ExpressWorldwideNonDoc',
                                      parcels: %w(JumboDocument JumboParcel Document DHLFlyer Domestic ExpressDocument DHLExpressEnvelope JumboBox JumboJuniorDocument JuniorJumboBox JumboJuniorParcel OtherDHLPackaging Parcel YourPackaging) }
      }.freeze

      BILL_TO = ['Sender', 'Receiver', '3rd Party']

      STATUSES = %w(not_shipped manually_shipped unknown pre_transit in_transit out_for_delivery return_to_sender delivered failure cancelled)

      self.table_name = 'refinery_parcels_shipments'

      belongs_to :from_contact,         class_name: '::Refinery::Marketing::Contact'
      belongs_to :from_address,         class_name: '::Refinery::Parcels::ShipmentAddress', dependent: :destroy
      belongs_to :to_contact,           class_name: '::Refinery::Marketing::Contact'
      belongs_to :to_address,           class_name: '::Refinery::Parcels::ShipmentAddress', dependent: :destroy
      belongs_to :created_by,           class_name: '::Refinery::Authentication::Devise::User'
      belongs_to :assigned_to,          class_name: '::Refinery::Authentication::Devise::User'
      belongs_to :bill_to_account,      class_name: '::Refinery::Parcels::ShipmentAccount'
      has_many :shipment_parcels,       dependent: :destroy

      serialize :rates_content, Array
      serialize :tracking_info, Array

      attr_writer :from_contact_name, :to_contact_name, :assign_to

      #attr_accessible :from_contact_name, :to_contact_name, :courier, :assign_to, :from_contact_id, :to_contact_id, :bill_to, :bill_to_account_id, :position, :created_by_id, :assigned_to_id

      validates :created_by_id,           presence: true
      validates :assigned_to_id,          presence: true
      validates :from_address_id,         uniqueness: true, allow_nil: true
      validates :to_address_id,           uniqueness: true, allow_nil: true
      validates :bill_to,                 inclusion: BILL_TO
      validates :status,                  inclusion: STATUSES
      validates :easypost_object_id,      uniqueness: true, allow_nil: true
      validates :from_address_id,         presence: true, unless: proc { @from_contact_name.present? }
      validates :to_address_id,           presence: true, unless: proc { @to_contact_name.present? }

      delegate :name, to: :from_contact,  prefix: true, allow_nil: true
      delegate :name, to: :to_contact,    prefix: true, allow_nil: true
      delegate :name, :street1, :street2, :city, :zip, :state, :country, :phone, :email, to: :from_address, prefix: true, allow_nil: true
      delegate :name, :street1, :street2, :city, :zip, :state, :country, :phone, :email, to: :to_address,   prefix: true, allow_nil: true

      before_validation do
        # Makes sure there is always address object present to assign values to. Even though it is
        # the same address for two different Shipments, we create uniq ShipmentAddress records for each
        # shipments.
        self.from_address ||= ShipmentAddress.new
        self.to_address ||= ShipmentAddress.new

        self.status ||= STATUSES.first

        # Try to find a contact to assign address values from
        if @from_contact_name.present?
          if from_contact.try(:name) == @from_contact_name
            from_address.assign_from_contact(from_contact)
          else
            self.from_contact = nil
            from_address.name = @from_contact_name
          end
          # if (contact = ::Refinery::Marketing::Contact.find_by_name(@from_contact_name)).present?
          #   self.from_contact = contact
          #   from_address.assign_from_contact(contact)
          # else
          #   from_address.name = @from_contact_name
          # end
        end

        # Try to find a contact to assign address values from
        if @to_contact_name.present?
          if to_contact.try(:name) == @to_contact_name
            to_address.assign_from_contact(to_contact)
          else
            self.to_contact = nil
            to_address.name = @to_contact_name
          end
          # if (contact = ::Refinery::Marketing::Contact.find_by_name(@to_contact_name)).present?
          #   self.to_contact = contact
          #   to_address.assign_from_contact(contact)
          # else
          #   to_address.name = @to_contact_name
          # end
        end

        # Try to find a user to assign the shipment to
        if @assign_to.present?
          self.assigned_to = ::Refinery::Authentication::Devise::User.find_by_full_name(@assign_to)
        end
        self.assigned_to ||= created_by
      end

      def assign_to
        @to ||= assigned_to.try(:full_name)
      end

      # Method used to check whether a particular user has the right to update the
      # shipment information. This is only used by the front-end controller, not the
      # admin controller.
      def editable_by?(user)
        return false unless user.present?

        created_by_id == user.id || assigned_to_id == user.id
      end

      def courier_predefined_packages
        (COURIERS[courier] || {})[:parcels] || []
      end

      def international?
        from_address.country != to_address.country
      end

      def available_accounts
        if bill_to == 'Receiver'
          if to_contact.present?
            if courier.blank?
              to_contact.shipment_accounts
            else
              to_contact.shipment_accounts.where(courier: courier)
            end
          else
            []
          end
        elsif bill_to == '3rd Party'
          ShipmentAccount.all
        else
          []
        end
      end

      def display_status
        ::I18n.t "activerecord.attributes.#{self.class.model_name.i18n_key}.statuses.#{status}"
      end


      def shippable?
        status == 'not_shipped' && shipment_parcels.exists?
      end

      class << self
        def easypost_couriers
          COURIERS.select { |_,v| v[:easypost] }.keys
        end

        def shipped_manually_not_delivered
          where("#{table_name}.easypost_object_id IS NULL AND #{table_name}.status IN (?)", %w(manually_shipped))
        end
      end

    end
  end
end
