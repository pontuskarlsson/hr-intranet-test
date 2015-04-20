module Refinery
  module Business
    class Budget < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_budgets'

      belongs_to :customer_contact, class_name: '::Refinery::Marketing::Contact'
      has_many :budget_items, dependent: :destroy

      attr_accessible :description, :position, :customer_name, :from_date, :to_date, :year, :time_period,
                      :no_of_products, :no_of_skus, :price, :quantity, :margin, :comments

      validates :description,   presence: true, uniqueness: true

      # Instantiates an instance of BudgetUpdater for the current Budget.
      def budget_form(params = {}, current_user = nil)
        @budget_form ||= BudgetForm.new_in_model(self, params, current_user)
      end

      def total
        price * quantity
      end

      def margin_total
        total * margin
      end

    end
  end
end
