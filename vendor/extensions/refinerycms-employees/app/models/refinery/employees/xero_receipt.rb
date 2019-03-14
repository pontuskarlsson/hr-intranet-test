module Refinery
  module Employees
    class XeroReceipt < Refinery::Core::BaseModel
      self.table_name = 'refinery_xero_receipts'

      STATUS_DRAFT          = 'DRAFT'
      STATUS_SUBMITTED      = 'SUBMITTED'
      STATUS_AUTHORISED     = 'AUTHORISED'
      STATUS_DECLINED       = 'DECLINED'
      STATUS_DELETED        = 'DELETED'
      STATUS_VOIDED         = 'VOIDED'
      STATUSES = [STATUS_DRAFT, STATUS_SUBMITTED, STATUS_AUTHORISED, STATUS_DECLINED, STATUS_DELETED, STATUS_VOIDED]

      belongs_to :employee # Remove, not assigned manually anyway and not used when submitting claim as of 2016-04-14
      belongs_to :xero_expense_claim
      belongs_to :xero_contact
      has_many :xero_line_items, dependent: :destroy

      accepts_nested_attributes_for :xero_line_items, allow_destroy: true, reject_if: proc { |attr| attr[:description].blank? }

      attr_writer :contact_name
      #attr_accessible :xero_contact_id, :contact_name, :date, :line_amount_types, :reference, :status, :sub_total, :total, :xero_line_items_attributes

      validates :xero_expense_claim_id,   presence: true
      validates :xero_contact_id,         presence: true
      validates :employee_id,             presence: true
      validates :status,                  inclusion: STATUSES
      validates :total,                   numericality: { greater_than_or_equal_to: 0 }

      before_validation do
        self.status ||= STATUS_DRAFT
        if @contact_name.present?
          self.xero_contact = XeroContact.find_or_create_by_name!(@contact_name.squish)
        end
      end

      # A Receipt is considered editable even when the status is deleted. The reason for
      # that is because if there was something wrong with the Expense Claim that was not
      # discovered until after it was approved, then it can be deleted from Xero, edited
      # here and then re-submitted again with minimum amount of work needed.
      def editable?
        status == STATUS_DRAFT || status == STATUS_DELETED
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
