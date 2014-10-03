module Refinery
  module Employees
    class XeroLineItem < Refinery::Core::BaseModel
      self.table_name = 'refinery_xero_line_items'

      belongs_to :xero_receipt
      belongs_to :xero_account

      attr_accessible :xero_account_id, :description, :discount_rate, :item_code, :quantity, :tax_amount, :tax_type, :unit_amount

      validates :description,     presence: true
      validates :quantity,        numericality: { greater_than: 0 }
      validates :line_amount,     numericality: { greater_than: 0 }
      validates :xero_account_id, presence: true

      before_validation do
        self.line_amount = line_total
      end

      def line_total
        quantity * unit_amount
      end

    end
  end
end
