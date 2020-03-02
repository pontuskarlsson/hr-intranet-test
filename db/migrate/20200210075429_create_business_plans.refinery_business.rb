# This migration comes from refinery_business (originally 26)
class CreateBusinessPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :refinery_business_plans do |t|
      t.integer :account_id
      t.integer :company_id
      t.integer :contract_id
      t.string :reference
      t.string :title
      t.text :description
      t.date :start_date
      t.date :end_date
      t.string :currency_code
      t.string :status
      t.datetime :confirmed_at
      t.integer :confirmed_by_id
      t.integer :payment_terms_days, null: false, default: 0
      t.integer :notice_period_months, null: false, default: 0
      t.integer :min_contract_period_months, null: false, default: 0
      t.datetime :notice_given_at
      t.integer :notice_given_by_id
      t.text :content
      t.text :meta
      t.integer :contact_person_id
      t.integer :account_manager_id
      t.text :payment_terms_content
      t.string :confirmed_from_ip

      t.timestamps
    end
    add_index :refinery_business_plans, :account_id
    add_index :refinery_business_plans, :company_id
    add_index :refinery_business_plans, :reference
    add_index :refinery_business_plans, :title
    add_index :refinery_business_plans, :start_date
    add_index :refinery_business_plans, :currency_code
    add_index :refinery_business_plans, :end_date
    add_index :refinery_business_plans, :status
    add_index :refinery_business_plans, :confirmed_at
    add_index :refinery_business_plans, :confirmed_by_id
    add_index :refinery_business_plans, :confirmed_from_ip
    add_index :refinery_business_plans, :notice_given_at
    add_index :refinery_business_plans, :notice_given_by_id
    add_index :refinery_business_plans, :contact_person_id
    add_index :refinery_business_plans, :account_manager_id
  end
end
