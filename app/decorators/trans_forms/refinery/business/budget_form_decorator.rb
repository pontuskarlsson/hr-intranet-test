Refinery::Business::BudgetForm.class_eval do

  # A method to return a list of BudgetItems for the Budget. It will make sure
  # that there are items present even if none have previously been added.
  def budget_items_for_list
    @budget_items_for_list ||=
      if budget.present?

        # Makes sure that there are at least 10 rows and at least 5 new rows
        # of BudgetItems.
        [10, budget.budget_items.length + 5].max.times do |i|
          budget.budget_items[i] || budget.budget_items.build
        end

        # Returns the list of BudgetItems which can consist of both persisted
        # and non-persisted records.
        budget.budget_items
      else
        []
      end
  end

end
