# This migration comes from refinery_business (originally 4)
class CreateBusinessBudgetItems < ActiveRecord::Migration

  def up
    create_table :refinery_business_budget_items do |t|
      t.integer :budget_id
      t.string :description
      t.integer :no_of_products, null: false, default: 0
      t.integer :no_of_skus, null: false, default: 0
      t.decimal :price, null: false, default: 0
      t.integer :quantity, null: false, default: 0
      t.decimal :margin, null: false, default: 0, precision: 6, scale: 5
      t.text :comments, null: false, default: ''

      t.integer :position
      t.timestamps
    end

    add_index :refinery_business_budget_items, :budget_id
  end

  def down
    remove_index :refinery_business_budget_items, :budget_id

    drop_table :refinery_business_budget_items

  end

end
