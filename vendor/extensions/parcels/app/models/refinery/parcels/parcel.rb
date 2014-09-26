module Refinery
  module Parcels
    class Parcel < Refinery::Core::BaseModel
      self.table_name = 'refinery_parcels'

      belongs_to :shipping_document,  class_name: '::Refinery::Resource'
      belongs_to :from_contact,       class_name: '::Refinery::Contacts::Contact'
      belongs_to :to_user,            class_name: '::Refinery::User'
      belongs_to :received_by,        class_name: '::Refinery::User'
      belongs_to :assigned_to,        class_name: '::Refinery::User'

      attr_writer :from, :to, :given_to

      attr_accessible :parcel_date, :from, :courier, :air_waybill_no, :to, :shipping_document_id, :position, :received_by, :assigned_to, :description, :given_to, :receiver_signed

      validates :parcel_date,     presence: true
      validates :from_name,       presence: true
      validates :courier,         presence: true
      validates :to_name,         presence: true
      validates :received_by_id,  presence: true
      validates :assigned_to_id,  presence: true

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
        if @given_to.present?
          self.assigned_to = ::Refinery::User.find_by_full_name(@given_to) || received_by
        end
        self.assigned_to ||= received_by
      end

      def from
        @from ||= from_contact.present? ? from_contact.name : from_name
      end

      def to
        @to ||= to_user.present? ? to_user.full_name : to_name
      end

      def given_to
        @given_to ||= assigned_to.try(:full_name)
      end

    end
  end
end
