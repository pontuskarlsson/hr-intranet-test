# This migration comes from refinery_business (originally 16)
class AddFromAndToToInvoices < ActiveRecord::Migration

  def change
    add_column :refinery_business_invoices, :from_company_id, :integer
    add_column :refinery_business_invoices, :from_company_label, :string
    add_column :refinery_business_invoices, :from_contact_id, :integer
    add_column :refinery_business_invoices, :to_company_id, :integer
    add_column :refinery_business_invoices, :to_company_label, :string
    add_column :refinery_business_invoices, :to_contact_id, :integer
    add_index :refinery_business_invoices, :from_company_id, name: 'INDEX_rb_invoices_ON_from_company_id'
    add_index :refinery_business_invoices, :from_company_label, name: 'INDEX_rb_invoices_ON_from_company_label'
    add_index :refinery_business_invoices, :from_contact_id, name: 'INDEX_rb_invoices_ON_from_contact_id'
    add_index :refinery_business_invoices, :to_company_id, name: 'INDEX_rb_invoices_ON_to_company_id'
    add_index :refinery_business_invoices, :to_company_label, name: 'INDEX_rb_invoices_ON_to_company_label'
    add_index :refinery_business_invoices, :to_contact_id, name: 'INDEX_rb_invoices_ON_to_contact_id'
  end

end
