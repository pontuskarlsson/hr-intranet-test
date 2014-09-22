class CreateSalesOrdersSalesOrders < ActiveRecord::Migration

  def up
    create_table :refinery_sales_orders do |t|
      t.string :order_id,  null: false, default: ''
      t.string :order_session_id,  null: false, default: ''
      t.string :order_ref,  null: false, default: ''
      t.datetime :created_date
      t.datetime :modified_date
      t.boolean :active,  null: false, default: 0
      t.string :transaction_type,  null: false, default: ''
      t.string :member_id,  null: false, default: ''
      t.string :member_email,  null: false, default: ''
      t.string :member_cost_center,  null: false, default: ''
      t.string :member_session_id,  null: false, default: ''
      t.string :sales_person_id,  null: false, default: ''
      t.string :sales_person_email,  null: false, default: ''
      t.decimal :product_total,  null: false, default: 0
      t.decimal :freight_total,  null: false, default: 0
      t.string :freight_description,  null: false, default: ''
      t.decimal :discount_total,  null: false, default: 0
      t.string :discount_description,  null: false, default: ''
      t.decimal :total,  null: false, default: 0
      t.decimal :currency_rate,  null: false, default: 0
      t.string :currency_name,  null: false, default: ''
      t.string :currency_symbol,  null: false, default: ''
      t.string :tax_status,  null: false, default: ''
      t.decimal :tax_rate,  null: false, default: 0
      t.string :first_name,  null: false, default: ''
      t.string :last_name,  null: false, default: ''
      t.string :company,  null: false, default: ''
      t.string :phone,  null: false, default: ''
      t.string :mobile,  null: false, default: ''
      t.string :email,  null: false, default: ''

      t.string :delivery_first_name,  null: false, default: ''
      t.string :delivery_last_name,   null: false, default: ''
      t.string :delivery_company,     null: false, default: ''
      t.string :delivery_address,     null: false, default: ''
      t.string :delivery_suburb,      null: false, default: ''
      t.string :delivery_city,        null: false, default: ''
      t.string :delivery_postal_code, null: false, default: ''
      t.string :delivery_state,       null: false, default: ''
      t.string :delivery_country,     null: false, default: ''

      t.string :billing_first_name,   null: false, default: ''
      t.string :billing_last_name,    null: false, default: ''
      t.string :billing_company,      null: false, default: ''
      t.string :billing_address,      null: false, default: ''
      t.string :billing_suburb,       null: false, default: ''
      t.string :billing_city,         null: false, default: ''
      t.string :billing_postal_code,  null: false, default: ''
      t.string :billing_state,        null: false, default: ''
      t.string :billing_country,      null: false, default: ''

      t.string :comments,  null: false, default: ''
      t.string :voucher_code,  null: false, default: ''
      t.string :branch_id,  null: false, default: ''
      t.string :branch_email,  null: false, default: ''
      t.string :stage,  null: false, default: ''
      t.string :cost_center,  null: false, default: ''
      t.string :tracking_code,  null: false, default: ''
      t.string :payment_terms,  null: false, default: ''

      t.integer :position
      t.timestamps
    end

    add_index :refinery_sales_orders, :order_id
    add_index :refinery_sales_orders, :active
    add_index :refinery_sales_orders, :position
  end

  def down
    remove_index :refinery_sales_orders, :order_id
    remove_index :refinery_sales_orders, :active
    remove_index :refinery_sales_orders, :position

    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-sales_orders"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/sales_orders/sales_orders"})
    end

    drop_table :refinery_sales_orders

  end

end
