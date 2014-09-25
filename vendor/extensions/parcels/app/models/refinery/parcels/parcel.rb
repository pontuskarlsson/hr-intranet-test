module Refinery
  module Parcels
    class Parcel < Refinery::Core::BaseModel
      self.table_name = 'refinery_parcels'

      belongs_to :shipping_document,  class_name: '::Refinery::Resource'
      belongs_to :from_contact,       class_name: '::Refinery::Contacts::Contact'
      belongs_to :to_user,            class_name: '::Refinery::User'

      attr_writer :from, :to

      attr_accessible :parcel_date, :from, :courier, :air_waybill_no, :to, :shipping_document_id, :position

      validates :parcel_date, presence: true
      validates :from_name,   presence: true
      validates :courier,     presence: true
      validates :to_name,     presence: true

      scope :unsigned, where(receiver_signed: false)

      before_validation do
        if @from.present?
          if (contact = ::Refinery::Contacts::Contact.find_by_name(@from)).present?
            self.from_contact = contact
          end
          self.from_name = @from
        end
        if @to.present?
          if (user = ::Refinery::User.find_by_full_name(@to)).present?
            self.to_user = user
          end
          self.to_name = @to
        end
      end

      def from
        @from ||= from_contact.present? ? from_contact.name : from_name
      end

      def to
        @to ||= to_user.present? ? to_user.full_name : to_name
      end

    end
  end
end
