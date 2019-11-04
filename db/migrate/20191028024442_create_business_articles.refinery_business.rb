# This migration comes from refinery_business (originally 23)
class CreateBusinessArticles < ActiveRecord::Migration

  def change
    create_table :refinery_business_articles do |t|
      t.string :account_id
      t.string :item_id
      t.string :code
      t.string :name
      t.text :description
      t.boolean :is_sold, null: false, default: false
      t.boolean :is_purchased, null: false, default: false
      t.decimal :purchase_unit_price, precision: 13, scale: 4, default: 0.0, null: false
      t.decimal :sales_unit_price, precision: 13, scale: 4, default: 0.0, null: false

      t.boolean :is_public, null: false, default: false
      t.integer :company_id

      t.boolean :is_managed, null: false, default: false
      t.datetime :updated_date_utc
      t.string :managed_status

      t.boolean :is_voucher, null: false, default: false
      t.text :voucher_constraint

      t.datetime :archived_at

      t.timestamps
    end

    add_index :refinery_business_articles, :account_id
    add_index :refinery_business_articles, :item_id
    add_index :refinery_business_articles, :code
    add_index :refinery_business_articles, :name
    add_index :refinery_business_articles, :is_sold
    add_index :refinery_business_articles, :is_purchased

    add_index :refinery_business_articles, :is_public
    add_index :refinery_business_articles, :company_id

    add_index :refinery_business_articles, :is_managed
    add_index :refinery_business_articles, :updated_date_utc
    add_index :refinery_business_articles, :managed_status

    add_index :refinery_business_articles, :is_voucher

    add_index :refinery_business_articles, :archived_at
  end

end
