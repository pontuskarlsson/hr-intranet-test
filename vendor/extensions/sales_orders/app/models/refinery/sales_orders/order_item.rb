module Refinery
  module SalesOrders
    class OrderItem < Refinery::Core::BaseModel
      self.table_name = 'refinery_order_items'

      belongs_to :sales_order

      validates :sales_order_id,  presence: true

      def total
        qty * price
      end
    end
  end
end
