module Refinery
  module Shipping
    class Parcel < Refinery::Core::BaseModel
      self.table_name = 'refinery_shipping_parcels'

      belongs_to :shipping_document,  class_name: '::Refinery::Resource'
      belongs_to :from_contact,       class_name: '::Refinery::Marketing::Contact'
      belongs_to :to_user,            class_name: '::Refinery::Authentication::Devise::User'
      belongs_to :received_by,        class_name: '::Refinery::Authentication::Devise::User'
      belongs_to :assigned_to,        class_name: '::Refinery::Authentication::Devise::User'

      attr_writer :from, :to, :given_to

      validates :parcel_date,     presence: true
      validates :from_name,       presence: true
      validates :courier,         presence: true
      validates :to_name,         presence: true
      validates :received_by_id,  presence: true
      validates :assigned_to_id,  presence: true

      scope :recent, -> (no_of_records = 10, days_ago = 90) { where('parcel_date > ?', Date.today - days_ago).order(parcel_date: :desc).limit(no_of_records) }
      scope :unsigned, -> { where(receiver_signed: false) }

      before_validation do
        if @from.present?
          if (contact = ::Refinery::Marketing::Contact.find_by_name(@from)).present?
            self.from_contact = contact
          end
          self.from_name = @from
        end
        if @to.present?
          if (user = ::Refinery::Authentication::Devise::User.find_by_full_name(@to)).present?
            self.to_user = user
          end
          self.to_name = @to
        end
        if @given_to.present?
          self.assigned_to = ::Refinery::Authentication::Devise::User.find_by_full_name(@given_to)
        end
        self.assigned_to ||= to_user || received_by
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

      # Method used to check whether a particular user has the right to update the
      # parcel information. This is only used by the front-end controller, not the
      # admin controller.
      def editable_by?(user)
        return false unless user.present?

        received_by_id == user.id || assigned_to_id == user.id
      end

    end
  end
end
