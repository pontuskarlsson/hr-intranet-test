# This migration comes from refinery_business (originally 30)
class CreateBusinessPurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :refinery_business_purchases do |t|
      t.integer :user_id
      t.integer :company_id
      t.integer :invoice_id
      t.string :status
      t.string :stripe_checkout_session_id
      t.string :stripe_payment_intent_id
      t.string :stripe_event_id
      t.string :stripe_charge_id
      t.string :stripe_payout_id
      t.string :discount_code
      t.decimal :sub_total_cost, precision: 13, scale: 4, default: "0.0", null: false
      t.decimal :total_discount, precision: 13, scale: 4, default: "0.0", null: false
      t.decimal :total_cost, precision: 13, scale: 4, default: "0.0", null: false
      t.text :meta

      t.timestamps
    end
    add_index :refinery_business_purchases, :user_id
    add_index :refinery_business_purchases, :company_id
    add_index :refinery_business_purchases, :invoice_id
    add_index :refinery_business_purchases, :status
    add_index :refinery_business_purchases, :stripe_checkout_session_id, name: 'INDEX_r_b_purchases_ON_stripe_checkout_session_id'
    add_index :refinery_business_purchases, :stripe_payment_intent_id, name: 'INDEX_r_b_purchases_ON_stripe_payment_intent_id'
    add_index :refinery_business_purchases, :stripe_event_id, name: 'INDEX_r_b_purchases_ON_stripe_event_id'
    add_index :refinery_business_purchases, :stripe_charge_id, name: 'INDEX_r_b_purchases_ON_stripe_charge_id'
    add_index :refinery_business_purchases, :stripe_payout_id, name: 'INDEX_r_b_purchases_ON_stripe_payout_id'
    add_index :refinery_business_purchases, :discount_code
  end
end
