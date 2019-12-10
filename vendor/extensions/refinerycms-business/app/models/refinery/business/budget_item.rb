module Refinery
  module Business
    class BudgetItem < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_budget_items'

      belongs_to :budget, optional: true

      #attr_accessible :budget_id, :description, :no_of_products, :no_of_skus, :price, :quantity, :margin, :comments, :position

      validates :budget_id,     presence: true
      validates :description,   presence: true

      def total_qty
        no_of_skus * quantity
      end

      def total
        total_qty * price
      end

      def margin_total
        total * margin
      end

      # Helper method to display the margin in percentage form instead of decimal form
      def margin_percent
        margin * 100.0
      end

    end
  end
end
