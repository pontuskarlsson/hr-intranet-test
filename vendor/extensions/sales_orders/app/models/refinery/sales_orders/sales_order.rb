module Refinery
  module SalesOrders
    class SalesOrder < Refinery::Core::BaseModel
      self.table_name = 'refinery_sales_orders'

      has_many :order_items, dependent: :destroy

      validates :order_id,       presence: true, uniqueness: true
    end
  end
end
