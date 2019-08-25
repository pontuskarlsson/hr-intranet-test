module Refinery
  module Business
    class SalesOrder < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_sales_orders'

      has_many :order_items, dependent: :destroy

      #attr_accessible :order_ref, :company, :billing_address, :delivery_address, :modified_date, :total, :currency_name, :position

      validates :order_ref,     presence: true, uniqueness: true
      validates :order_id,      uniqueness: true, allow_blank: true

      def self.for_user_roles(user, role_titles = nil)
        titles = role_titles || user.roles.pluck(:title)

        if titles.include? ROLE_INTERNAL
          where(nil)
        else
          where('1=0')
        end
      end

    end
  end
end
