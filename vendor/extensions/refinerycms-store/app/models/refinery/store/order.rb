module Refinery
  module Store
    class Order < Refinery::Core::BaseModel
      self.table_name = 'refinery_store_orders'

      belongs_to :user,     class_name: '::Refinery::User'
      belongs_to :retailer
      has_many :order_items,    dependent: :destroy

      attr_accessible :order_number, :reference, :total_price, :user_id, :status, :position, :retailer_id

      validates :retailer_id,   presence: true
      validates :order_number,  presence: true, uniqueness: { scope: :retailer_id }

      before_validation do
        self.price_unit = retailer.try(:default_price_unit)
        self.order_number = order_number.present? ? order_number :
            if (o = Order.order('order_number DESC').first).present?
              (o.order_number.to_i + 1).to_s.rjust(10, '0')
            else
              '0000000001'
            end
      end

    end
  end
end
