class CreatePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :purchases do |t|
      t.integer :user_id
      t.integer :company_id
      t.string :status
      t.string :stripe_checkout_session_id
      t.string :stripe_payment_intent_id
      t.string :stripe_event_id
      t.string :discount_code
      t.decimal :sub_total_cost, precision: 13, scale: 4, default: "0.0", null: false
      t.decimal :total_discount, precision: 13, scale: 4, default: "0.0", null: false
      t.decimal :total_cost, precision: 13, scale: 4, default: "0.0", null: false
      t.text :meta

      t.timestamps
    end
    add_index :purchases, :user_id
    add_index :purchases, :company_id
    add_index :purchases, :status
    add_index :purchases, :stripe_checkout_session_id
    add_index :purchases, :stripe_payment_intent_id
    add_index :purchases, :stripe_event_id
    add_index :purchases, :discount_code
  end
end
