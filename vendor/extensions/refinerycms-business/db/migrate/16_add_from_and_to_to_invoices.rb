class AddFromAndToToInvoices < ActiveRecord::Migration

  def change
    add_column :refinery_business_invoices, :from_company_id, :integer
    add_column :refinery_business_invoices, :from_company_label, :string
    add_column :refinery_business_invoices, :from_contact_id, :integer
    add_column :refinery_business_invoices, :to_company_id, :integer
    add_column :refinery_business_invoices, :to_company_label, :string
    add_column :refinery_business_invoices, :to_contact_id, :integer
    add_column :refinery_business_invoices, :archived_at, :datetime
    add_column :refinery_business_invoices, :is_managed, :boolean, null: false, default: false
    add_column :refinery_business_invoices, :managed_status, :string
    add_column :refinery_business_invoices, :invoice_for_month, :date
    add_column :refinery_business_invoices, :plan_details, :text
    add_column :refinery_business_invoices, :buyer_reference, :string
    add_column :refinery_business_invoices, :seller_reference, :string
    add_index :refinery_business_invoices, :from_company_id, name: 'INDEX_rb_invoices_ON_from_company_id'
    add_index :refinery_business_invoices, :from_company_label, name: 'INDEX_rb_invoices_ON_from_company_label'
    add_index :refinery_business_invoices, :from_contact_id, name: 'INDEX_rb_invoices_ON_from_contact_id'
    add_index :refinery_business_invoices, :to_company_id, name: 'INDEX_rb_invoices_ON_to_company_id'
    add_index :refinery_business_invoices, :to_company_label, name: 'INDEX_rb_invoices_ON_to_company_label'
    add_index :refinery_business_invoices, :to_contact_id, name: 'INDEX_rb_invoices_ON_to_contact_id'
    add_index :refinery_business_invoices, :archived_at, name: 'INDEX_rb_invoices_ON_archived_at'
    add_index :refinery_business_invoices, :is_managed, name: 'INDEX_rb_invoices_ON_is_managed'
    add_index :refinery_business_invoices, :managed_status, name: 'INDEX_rb_invoices_ON_managed_status'
    add_index :refinery_business_invoices, :invoice_for_month, name: 'INDEX_rb_invoices_ON_invoice_for_month'
    add_index :refinery_business_invoices, :buyer_reference, name: 'INDEX_rb_invoices_ON_buyer_reference'
    add_index :refinery_business_invoices, :seller_reference, name: 'INDEX_rb_invoices_ON_seller_reference'
  end

end
