module Refinery
  module Shipping
    class ShipmentAddressUpdater < TransForms::FormBase
      ATTRIBUTES = %w(name street1 street2 city zip state country phone email)

      set_main_model :shipment
      
      attribute :from_address_name,       String,  default: proc { |f| f.shipment.from_address_name }
      attribute :from_address_street1,    String,  default: proc { |f| f.shipment.from_address_street1 }
      attribute :from_address_street2,    String,  default: proc { |f| f.shipment.from_address_street2 }
      attribute :from_address_city,       String,  default: proc { |f| f.shipment.from_address_city }
      attribute :from_address_zip,        String,  default: proc { |f| f.shipment.from_address_zip }
      attribute :from_address_state,      String,  default: proc { |f| f.shipment.from_address_state }
      attribute :from_address_country,    String,  default: proc { |f| f.shipment.from_address_country }
      attribute :from_address_phone,      String,  default: proc { |f| f.shipment.from_address_phone }
      attribute :from_address_email,      String,  default: proc { |f| f.shipment.from_address_email }

      attribute :to_address_name,         String,  default: proc { |f| f.shipment.to_address_name }
      attribute :to_address_street1,      String,  default: proc { |f| f.shipment.to_address_street1 }
      attribute :to_address_street2,      String,  default: proc { |f| f.shipment.to_address_street2 }
      attribute :to_address_city,         String,  default: proc { |f| f.shipment.to_address_city }
      attribute :to_address_zip,          String,  default: proc { |f| f.shipment.to_address_zip }
      attribute :to_address_state,        String,  default: proc { |f| f.shipment.to_address_state }
      attribute :to_address_country,      String,  default: proc { |f| f.shipment.to_address_country }
      attribute :to_address_phone,        String,  default: proc { |f| f.shipment.to_address_phone }
      attribute :to_address_email,        String,  default: proc { |f| f.shipment.to_address_email }

      validates :shipment, presence: true

      transaction do
        confirm_address_presence!

        shipment.from_address.attributes = ATTRIBUTES.inject({}) { |acc, attr| acc.merge(attr => send("from_address_#{attr}")) }
        shipment.from_address.save!

        shipment.to_address.attributes = ATTRIBUTES.inject({}) { |acc, attr| acc.merge(attr => send("to_address_#{attr}")) }
        shipment.to_address.save!
      end

      def persisted?
        shipment && shipment.persisted?
      end

      protected
      def confirm_address_presence!
        shipment.from_address ||= ShipmentAddress.new
        shipment.to_address ||= ShipmentAddress.new
        shipment.to_address.save! # Will only perform update if anything is changed
      end
    end

  end
end
