module Refinery
  module Business
    class Budget < Refinery::Core::BaseModel

      self.table_name = 'refinery_business_budgets'

      belongs_to :customer_contact, class_name: '::Refinery::Marketing::Contact', optional: true
      has_many :budget_items, dependent: :destroy

      #attr_accessible :description, :position, :customer_name, :from_date, :to_date,
      #                :no_of_products, :no_of_skus, :price, :quantity, :margin, :comments

      validates :description,   presence: true, uniqueness: true

      # Instantiates an instance of BudgetUpdater for the current Budget.
      def budget_form(params = {}, current_user = nil)
        @budget_form ||= BudgetForm.new_in_model(self, params, current_user)
      end

      # Since the percentage value is stored in a decimal column, i.e. the
      # value 25% is stored as 0.25, so this method converts that value into
      # a more presentable format that can be used in views and form fields.
      def margin_percent
        margin * 100
      end

      # A method to display which quarter the Budget is in.
      def quarter
        if from_date.present?
          ::Refinery::Business::QUARTERS.detect { |_,v| v === from_date.month }[0]
        end
      end

      def year
        if from_date.present?
          from_date.year
        end
      end

    end
  end
end
