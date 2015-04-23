class AddTotalsToBudgets < ActiveRecord::Migration

  def up
    add_column :refinery_business_budgets, :total, :decimal, null: false, default: 0, precision: 8, scale: 2
    add_column :refinery_business_budgets, :margin_total, :decimal, null: false, default: 0, precision: 8, scale: 2
  end

  def down
    remove_column :refinery_business_budgets, :total
    remove_column :refinery_business_budgets, :margin_total
  end

end
