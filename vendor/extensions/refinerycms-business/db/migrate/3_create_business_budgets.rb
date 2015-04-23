class CreateBusinessBudgets < ActiveRecord::Migration

  def up
    create_table :refinery_business_budgets do |t|
      t.string :description,  null: false, default: ''

      t.string :customer_name, null: false, default: ''
      t.integer :customer_contact_id

      t.date :from_date
      t.date :to_date

      t.string :account_manager_name, null: false, default: ''
      t.integer :account_manager_user_id

      t.integer :no_of_products, null: false, default: 0
      t.integer :no_of_skus, null: false, default: 0
      t.decimal :price, null: false, default: 0, precision: 8, scale: 2
      t.integer :quantity, null: false, default: 0
      t.decimal :margin, null: false, default: 0, precision: 6, scale: 5

      t.text :comments

      t.integer :position
      t.timestamps
    end

    add_index :refinery_business_budgets, :description
    add_index :refinery_business_budgets, :customer_contact_id
    add_index :refinery_business_budgets, :account_manager_user_id
  end

  def down
    remove_index :refinery_business_budgets, :description
    remove_index :refinery_business_budgets, :customer_contact_id
    remove_index :refinery_business_budgets, :account_manager_user_id

    drop_table :refinery_business_budgets

  end

end
