Refinery::Business::BudgetForm.class_eval do

  attribute :year,        Integer, default: proc { |f| f.budget.year }
  attribute :quarter,     String, default: proc { |f| f.budget.quarter }

  validates :year,      presence: true,
                        format: { with: /\A(19|20)\d{2}\z/i, message: 'should be a four-digit year' }
  validates :quarter,   inclusion: ::Refinery::Business::QUARTERS.keys

  before_save do
    self.from_date = Date.new(year.to_i, ::Refinery::Business::QUARTERS[quarter].first, 1)
    self.to_date = from_date + 3.months - 1.day
  end

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
