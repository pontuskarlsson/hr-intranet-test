module Refinery
  module Shipping
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

      #EASYPOST_STATUSES = %w(unknown pre_transit in_transit out_for_delivery return_to_sender delivered failure cancelled)
      STATUSES = %w(draft shipped delivered cancelled)

      SHIP_MODES = %w(Air Courier Rail Road Sea Sea-Air)

      self.table_name = 'refinery_shipping_shipments'


      # SHIPPER
      #
      # Freight Forwarder
      # The company from where the goods are being sent, usually the factory.
      #
      # Courier
      # The company that ships the parcel
      #
      belongs_to :shipper_company,      class_name: '::Refinery::Business::Company'
      belongs_to :from_contact,         class_name: '::Refinery::Marketing::Contact'
      belongs_to :from_address,         class_name: '::Refinery::Shipping::Address', dependent: :destroy


      # RECEIVER
      #
      # Freight Forwarder
      # The company who receives the goods that are being sent, usually the customer.
      # Might also be the Consignee, but not always.
      #
      # Courier
      # The company that receives the parcel
      #
      belongs_to :receiver_company,     class_name: '::Refinery::Business::Company'
      belongs_to :to_contact,           class_name: '::Refinery::Marketing::Contact'
      belongs_to :to_address,           class_name: '::Refinery::Shipping::Address', dependent: :destroy


      # CONSIGNEE
      #
      # Freight Forwarder
      # The company responsible for taking ownership of the shipment according to payment
      # terms. Usually the same as Receiver company, but not always.
      #
      # Courier
      # The company that pays for the shipment.
      #
      belongs_to :consignee_company,    class_name: '::Refinery::Business::Company'
      belongs_to :consignee_address,    class_name: '::Refinery::Shipping::Address', dependent: :destroy


      # SUPPLIER
      #
      # Freight Forwarder
      # The company to which the purchase order(s) where placed that corresponds to the
      # goods that are being shipped. Might be same as Shipper, but often the Factory is
      # a separate company.
      #
      # Courier
      # N/A
      #
      belongs_to :supplier_company,     class_name: '::Refinery::Business::Company'


      # FORWARDER
      #
      # Freight Forwarder
      # The Freight Forwarder company
      #
      # Courier
      # N/A
      #
      belongs_to :forwarder_company,    class_name: '::Refinery::Business::Company'

      # COURIER
      #
      # Freight Forwarder
      # N/A
      #
      # Courier
      # The Courier company
      #
      belongs_to :courier_company,      class_name: '::Refinery::Business::Company'


      belongs_to :created_by,           class_name: '::Refinery::Authentication::Devise::User'
      belongs_to :assigned_to,          class_name: '::Refinery::Authentication::Devise::User'
      belongs_to :bill_to_account,      class_name: '::Refinery::Shipping::ShipmentAccount'
      belongs_to :project,              class_name: '::Refinery::Business::Project'
      has_many :shipment_parcels,       dependent: :destroy
      has_many :packages,               dependent: :destroy
      has_many :items,                  dependent: :destroy
      has_many :routes,                 dependent: :destroy

      serialize :rates_content, Array
      serialize :tracking_info, Array

      validates :from_address_id,         uniqueness: true, allow_nil: true
      validates :to_address_id,           uniqueness: true, allow_nil: true
      #validates :bill_to,                 inclusion: BILL_TO, if: :shipped_by_easypost?
      #validates :status,                  inclusion: EASYPOST_STATUSES, if: :shipped_by_easypost?
      #validates :easypost_object_id,      uniqueness: true, allow_nil: true

      delegate :name, to: :to_contact,    prefix: true, allow_nil: true
      delegate :name, :street1, :street2, :city, :zip, :state, :country, :phone, :email, to: :from_address, prefix: true, allow_nil: true
      delegate :name, :street1, :street2, :city, :zip, :state, :country, :phone, :email, to: :to_address,   prefix: true, allow_nil: true

      # before_validation do
      #   # Makes sure there is always address object present to assign values to. Even though it is
      #   # the same address for two different Shipments, we create uniq ShipmentAddress records for each
      #   # shipments.
      #   self.from_address ||= ShipmentAddress.new
      #   self.to_address ||= ShipmentAddress.new
      #
      #   self.status ||= STATUSES.first
      #
      #   # Try to find a contact to assign address values from
      #   if @from_contact_name.present?
      #     if from_contact.try(:name) == @from_contact_name
      #       from_address.assign_from_contact(from_contact)
      #     else
      #       self.from_contact = nil
      #       from_address.name = @from_contact_name
      #     end
      #     # if (contact = ::Refinery::Marketing::Contact.find_by_name(@from_contact_name)).present?
      #     #   self.from_contact = contact
      #     #   from_address.assign_from_contact(contact)
      #     # else
      #     #   from_address.name = @from_contact_name
      #     # end
      #   end
      #
      #   # Try to find a contact to assign address values from
      #   if @to_contact_name.present?
      #     if to_contact.try(:name) == @to_contact_name
      #       to_address.assign_from_contact(to_contact)
      #     else
      #       self.to_contact = nil
      #       to_address.name = @to_contact_name
      #     end
      #     # if (contact = ::Refinery::Marketing::Contact.find_by_name(@to_contact_name)).present?
      #     #   self.to_contact = contact
      #     #   to_address.assign_from_contact(contact)
      #     # else
      #     #   to_address.name = @to_contact_name
      #     # end
      #   end
      #
      #   # Try to find a user to assign the shipment to
      #   if @assign_to.present?
      #     self.assigned_to = ::Refinery::Authentication::Devise::User.find_by_full_name(@assign_to)
      #   end
      #   self.assigned_to ||= created_by
      # end

      before_validation(on: :create) do
        self.code = ::Refinery::Business::NumberSerie.next_counter!(self.class, :code) if code.blank?

        self.status ||= 'draft'

        if mode.present? && mode != 'Courier'
          self.supplier_company ||= shipper_company
          self.consignee_company ||= receiver_company
        end
      end

      before_save do
        self.shipper_company_label =    shipper_company.label     if shipper_company.present?
        self.from_contact =             shipper_company.contact   if shipper_company.present?
        self.from_contact_label =       from_contact.label        if from_contact.present?

        self.receiver_company_label =   receiver_company.label    if receiver_company.present?
        self.to_contact =               receiver_company.contact  if receiver_company.present?
        self.to_contact_label =         to_contact.label          if to_contact.present?

        self.consignee_company_label =  consignee_company.label   if consignee_company.present?
        self.supplier_company_label =   supplier_company.label    if supplier_company.present?
        self.forwarder_company_label =  forwarder_company.label   if forwarder_company.present?
        self.courier_company_label =    courier_company.label     if courier_company.present?

        self.assigned_to_label =        assigned_to.label         if assigned_to.present?
        self.created_by_label =         created_by.label          if created_by.present?

        if receiver_company.present? && (length_unit.blank? || weight_unit.blank?)
          last_created_shipment = receiver_company.receiver_shipments.where.not(id: id).order(created_at: :desc).first

          self.length_unit = last_created_shipment.try(:length_unit) || 'cm' if length_unit.blank?
          self.weight_unit = last_created_shipment.try(:weight_unit) || 'kg' if weight_unit.blank?
        end
      end

      scope :shipped,     -> { where(status: STATUSES - %w(not_shipped)) }
      scope :recent,      -> (no_of_records = 10, days_ago = 90) { where('shipping_date > ?', Date.today - days_ago).order(shipping_date: :desc).limit(no_of_records) }
      scope :forwarder,   -> { where.not(forwarder_company_id: nil).includes(:forwarder_company) }
      scope :active,      -> { where.not(status: %w(delivered cancelled)) }

      def self.for_user_roles(user, role_titles = nil)
        titles = role_titles || user.roles.pluck(:title)
        if titles.include? Refinery::Shipping::ROLE_INTERNAL
          where(nil)

        elsif titles.include? Refinery::Shipping::ROLE_EXTERNAL_FF
          where(forwarder_company_id: user.company_ids)

        else
          where('1=0')
        end
      end

      def self.to_source
        where(nil).pluck(:code).to_json.html_safe
      end

      def self.find_by_label(label)
        find_by_code label
      end

      def label
        code
      end

      # Method used to check whether a particular user has the right to update the
      # shipment information. This is only used by the front-end controller, not the
      # admin controller.
      def editable_by?(user)
        return false unless user.present?

        created_by_id == user.id || assigned_to_id == user.id
      end

      # def easypost_courier
      #   {
      #       'DHL' => 'DHL'
      #   }[courier_company_label]
      # end

      # def courier_predefined_packages
      #   (COURIERS[easypost_courier] || {})[:parcels] || []
      # end

      def international?
        from_address.country != to_address.country
      end

      def available_accounts
        if bill_to == 'Receiver'
          if to_contact.present?
            if courier_company_label.blank?
              to_contact.shipment_accounts
            else
              to_contact.shipment_accounts.where(courier: courier_company_label)
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
        if status.present?
          ::I18n.t "activerecord.attributes.#{self.class.model_name.i18n_key}.statuses.#{status}"
        end
      end

      def self.status_options
        ::I18n.t("activerecord.attributes.#{model_name.i18n_key}.statuses").reduce([['Please select', { disabled: true }]]) { |acc, (k,v)| acc << [v,k] }
      end


      def shippable?
        status == 'not_shipped' && shipment_parcels.exists?
      end

      def shipped_by_courier?
        courier_company_label.present?
      end

      # def shipped_by_easypost?
      #   mode == 'easypost'
      # end

      def supplier_different_from_shipper?
        supplier_company_label.present? && supplier_company_label != shipper_company_label
      end

      def consignee_different_from_receiver?
        consignee_company_label.present? && consignee_company_label != receiver_company_label
      end

      def courier_forwarder_company_label
        if courier_company_label.present?
          courier_company_label
        elsif forwarder_company_label.present?
          forwarder_company_label
        end
      end

      %w(gross_weight net_weight chargeable_weight).each do |w|
        define_method "display_#{w}" do
          amount = send("#{w}_manual_amount").presence || send("#{w}_amount").presence
          "#{amount} #{weight_unit}" if amount
        end
      end

      def display_volume
        amount = volume_manual_amount.presence || volume_amount.presence
        "#{amount} #{volume_unit}" if amount
      end

      %w(consignee courier forwarder receiver shipper supplier).each do |company|
        define_method("#{company}_company_label=") do |label|
          self.send("#{company}_company=", ::Refinery::Business::Company.find_by_label(label))
          super label
        end
      end
      # def forwarder_company_label=(label)
      #   self.forwarder_company = ::Refinery::Business::Company.find_by_label label
      #   super
      # end

      Route::TYPES.each do |route_type|
        define_method :"route_#{route_type}" do
          routes.detect { |d| d.route_type == route_type } || ::Refinery::Shipping::Route.new(route_type: route_type)
        end
      end

      class << self
        # def easypost_couriers
        #   COURIERS.select { |_,v| v[:easypost] }.keys
        # end

        # Only used by background tracker at the moment
        def shipped_not_delivered
          where('1=0')
          #where(status: %w(shipped))
        end

        def from_params(params)
          active = ActiveRecord::Type::Boolean.new.type_cast_from_user(params.fetch(:active, true))
          archived = ActiveRecord::Type::Boolean.new.type_cast_from_user(params.fetch(:archived, true))

          if active && archived
            where(nil)
          elsif active
            where(archived_at: nil)
          elsif archived
            where.not(archived_at: nil)
          else
            where('1=0')
          end
        end
      end

    end
  end
end
