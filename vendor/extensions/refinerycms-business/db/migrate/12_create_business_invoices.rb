class CreateBusinessInvoices < ActiveRecord::Migration

  def change
    create_table :refinery_business_invoices do |t|
      t.integer :account_id
      t.string :invoice_id
      t.string :contact_id
      t.string :invoice_number
      t.string :invoice_type
      t.string :reference
      t.string :invoice_url
      t.date :invoice_date
      t.date :due_date
      t.string :status
      t.decimal :total_amount, precision: 12, scale: 2, default: 0
      t.decimal :amount_due, precision: 12, scale: 2, default: 0
      t.decimal :amount_paid, precision: 12, scale: 2, default: 0
      t.decimal :amount_credited, precision: 12, scale: 2, default: 0
      t.string :currency_code
      t.decimal :currency_rate, precision: 12, scale: 6, default: 1
      t.datetime :updated_date_utc

      t.integer :position
      t.timestamps
    end

    add_index :refinery_business_invoices, :account_id
    add_index :refinery_business_invoices, :invoice_id
    add_index :refinery_business_invoices, :contact_id
    add_index :refinery_business_invoices, :invoice_number
    add_index :refinery_business_invoices, :invoice_date
    add_index :refinery_business_invoices, :invoice_type
    add_index :refinery_business_invoices, :status
    add_index :refinery_business_invoices, :total_amount

    add_index :refinery_business_invoices, :position
  end

end
