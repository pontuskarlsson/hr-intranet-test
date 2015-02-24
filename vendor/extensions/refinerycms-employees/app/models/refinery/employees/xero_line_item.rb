module Refinery
  module Employees
    class XeroLineItem < Refinery::Core::BaseModel
      self.table_name = 'refinery_xero_line_items'

      belongs_to :xero_receipt
      belongs_to :xero_account

      # This is where we store information about selected
      # Tracking Category Options. The keys will be guids
      # for Tracking Categories and the values will be the
      # guid of the selected Option for that Category.
      serialize :tracking_categories_and_options, Hash

      attr_accessible :xero_account_id, :description, :discount_rate, :item_code, :quantity,
                      :tax_amount, :tax_type, :unit_amount, :tracking_categories_and_options

      # Not validating presence of xero_receipt because it is
      # being added through +accepts_nested_attributes_for+ and
      # the id will not be present when record is being validated
      validates :description,     presence: true
      validates :quantity,        numericality: { greater_than: 0 }
      validates :unit_amount,     numericality: { greater_than: 0 }
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
