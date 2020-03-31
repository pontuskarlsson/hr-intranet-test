# This migration comes from refinery_business (originally 24)
class CreateBusinessVouchers < ActiveRecord::Migration

  def change
    create_table :refinery_business_vouchers do |t|
      t.integer :company_id

      t.integer :article_id
      t.integer :line_item_sales_purchase_id
      t.integer :line_item_sales_discount_id
      t.integer :line_item_sales_move_from_id
      t.integer :line_item_prepay_move_to_id
      t.integer :line_item_prepay_move_from_id
      t.integer :line_item_sales_move_to_id
      t.integer :line_item_prepay_in_id
      t.integer :line_item_prepay_discount_in_id
      t.integer :line_item_prepay_out_id
      t.integer :line_item_prepay_discount_out_id

      t.string :discount_type
      t.decimal :base_amount, precision: 13, scale: 4
      t.decimal :discount_amount, precision: 13, scale: 4
      t.decimal :discount_percentage, precision: 9, scale: 6
      t.decimal :amount, precision: 13, scale: 4

      t.string :currency_code
      t.datetime :valid_from
      t.datetime :valid_to

      t.string :status

      t.string :code

      t.string :source

      t.timestamps
    end

    add_index :refinery_business_vouchers, :company_id, name: 'INDEX_rb_vouchers_ON_company_id'
    add_index :refinery_business_vouchers, :article_id, name: 'INDEX_rb_vouchers_ON_article_id'
    add_index :refinery_business_vouchers, :line_item_sales_purchase_id, name: 'INDEX_rb_vouchers_ON_line_item_sales_purchase_id'
    add_index :refinery_business_vouchers, :line_item_sales_discount_id, name: 'INDEX_rb_vouchers_ON_line_item_sales_discount_id'
    add_index :refinery_business_vouchers, :line_item_sales_move_from_id, name: 'INDEX_rb_vouchers_ON_line_item_sales_move_from_id'
    add_index :refinery_business_vouchers, :line_item_prepay_move_to_id, name: 'INDEX_rb_vouchers_ON_line_item_prepay_move_to_id'
    add_index :refinery_business_vouchers, :line_item_prepay_move_from_id, name: 'INDEX_rb_vouchers_ON_line_item_prepay_move_from_id'
    add_index :refinery_business_vouchers, :line_item_sales_move_to_id, name: 'INDEX_rb_vouchers_ON_line_item_sales_move_to_id'
    add_index :refinery_business_vouchers, :line_item_prepay_in_id, name: 'INDEX_rb_vouchers_ON_line_item_prepay_in_id'
    add_index :refinery_business_vouchers, :line_item_prepay_discount_in_id, name: 'INDEX_rb_vouchers_ON_line_item_prepay_discount_in_id'
    add_index :refinery_business_vouchers, :line_item_prepay_out_id, name: 'INDEX_rb_vouchers_ON_line_item_prepay_out_id'
    add_index :refinery_business_vouchers, :line_item_prepay_discount_out_id, name: 'INDEX_rb_vouchers_ON_line_item_prepay_discount_out_id'
    add_index :refinery_business_vouchers, :discount_type, name: 'INDEX_rb_vouchers_ON_disount_type'
    add_index :refinery_business_vouchers, :currency_code, name: 'INDEX_rb_vouchers_ON_currency_code'
    add_index :refinery_business_vouchers, :valid_from, name: 'INDEX_rb_vouchers_ON_valid_from'
    add_index :refinery_business_vouchers, :valid_to, name: 'INDEX_rb_vouchers_ON_valid_to'
    add_index :refinery_business_vouchers, :status, name: 'INDEX_rb_vouchers_ON_status'
    add_index :refinery_business_vouchers, :code, name: 'INDEX_rb_vouchers_ON_code'
    add_index :refinery_business_vouchers, :source
  end

end
