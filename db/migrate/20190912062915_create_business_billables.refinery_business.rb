# This migration comes from refinery_business (originally 15)
class CreateBusinessBillables < ActiveRecord::Migration

  def change
    create_table :refinery_business_billables do |t|
      t.integer  :company_id
      t.integer  :project_id
      t.integer  :section_id
      t.integer  :invoice_id

      t.string   :billable_type
      t.string   :status

      t.string   :title
      t.text     :description

      t.string   :article_code
      t.decimal  :qty
      t.string   :qty_unit
      t.decimal  :unit_price, null: false, default: 0, precision: 13, scale: 4
      t.decimal  :discount, null: false, default: 0, precision: 12, scale: 6
      t.decimal  :total_cost, null: false, default: 0, precision: 13, scale: 4
      t.string   :account

      t.timestamps
    end

    add_index :refinery_business_billables, :company_id
    add_index :refinery_business_billables, :project_id
    add_index :refinery_business_billables, :section_id
    add_index :refinery_business_billables, :invoice_id
    add_index :refinery_business_billables, :billable_type
    add_index :refinery_business_billables, :status
    add_index :refinery_business_billables, :title
    add_index :refinery_business_billables, :article_code
    add_index :refinery_business_billables, :qty
    add_index :refinery_business_billables, :qty_unit
    add_index :refinery_business_billables, :unit_price
    add_index :refinery_business_billables, :total_cost
    add_index :refinery_business_billables, :account
  end

end
