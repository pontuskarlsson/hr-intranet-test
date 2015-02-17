module Refinery
  module Employees
    class XeroReceipt < Refinery::Core::BaseModel
      self.table_name = 'refinery_xero_receipts'

      STATUS_DRAFT          = 'DRAFT'
      STATUS_SUBMITTED      = 'SUBMITTED'
      STATUS_AUTHORISED     = 'AUTHORISED'
      STATUS_DECLINED       = 'DECLINED'
      STATUSES = [STATUS_DRAFT, STATUS_SUBMITTED, STATUS_AUTHORISED, STATUS_DECLINED]

      belongs_to :employee
      belongs_to :xero_expense_claim
      belongs_to :xero_contact
      has_many :xero_line_items, dependent: :destroy

      accepts_nested_attributes_for :xero_line_items, allow_destroy: true, reject_if: proc { |attr| attr[:description].blank? }

      attr_writer :contact_name
      attr_accessible :xero_contact_id, :contact_name, :date, :line_amount_types, :reference, :status, :sub_total, :total, :xero_line_items_attributes

      validates :xero_expense_claim_id,   presence: true
      validates :xero_contact_id,         presence: true
      validates :employee_id,             presence: true
      validates :status,                  inclusion: STATUSES
      validates :total,                   numericality: { greater_than: 0 }

      before_validation do
        self.status ||= STATUS_DRAFT
        if @contact_name.present?
          self.xero_contact = XeroContact.find_or_create_by_name!(@contact_name)
        end
      end

      def editable?
        status == 'Not-Submitted'
      end

      def no_of_items
        xero_line_items.count
      end

      def contact_name
        xero_contact.try(:name)
      end

    end
  end
end
