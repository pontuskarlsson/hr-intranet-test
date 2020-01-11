module Refinery
  module Shipping
    class ShipmentAccount < Refinery::Core::BaseModel
      self.table_name = 'refinery_shipping_shipment_accounts'

      belongs_to :contact,  class_name: '::Refinery::Marketing::Contact', optional: true
      has_many :shipments,  foreign_key: :bill_to_account_id, dependent: :nullify

      attr_writer :contact_name

      #attr_accessible :contact_id, :courier, :description, :account_no, :contact_name, :position

      validates :contact_id,    presence: true
      validates :description,   presence: true
      validates :account_no,    presence: true

      def contact_name
        @contact_name ||= contact.try(:name)
      end

      before_validation do
        # Try to find a contact to assign address values from
        if @contact_name.present?
          self.contact = ::Refinery::Marketing::Contact.find_by_name(@contact_name)
        end
      end

      def account_and_description
        "#{account_no} - #{description}"
      end

    end
  end
end
