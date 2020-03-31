# This migration comes from refinery_business (originally 17)
class AddAssignedToToBillables < ActiveRecord::Migration

  def change
    add_column :refinery_business_billables, :assigned_to_id, :integer
    add_column :refinery_business_billables, :assigned_to_label, :string
    add_column :refinery_business_billables, :archived_at, :datetime
    add_column :refinery_business_billables, :article_id, :integer
    add_column :refinery_business_billables, :line_item_sales_id, :integer
    add_column :refinery_business_billables, :line_item_discount_id, :integer
    add_column :refinery_business_billables, :billed_company_id, :integer
    add_column :refinery_business_billables, :billed_invoice_id, :integer
    add_column :refinery_business_billables, :bill_happy_rabbit, :boolean, null: false, default: false
    add_index :refinery_business_billables, :assigned_to_id, name: 'INDEX_rb_billables_ON_assigned_to_id'
    add_index :refinery_business_billables, :assigned_to_label, name: 'INDEX_rb_billables_ON_assigned_to_label'
    add_index :refinery_business_billables, :archived_at, name: 'INDEX_rb_billables_ON_archived_at'
    add_index :refinery_business_billables, :article_id, name: 'INDEX_rb_billables_ON_article_id'
    add_index :refinery_business_billables, :line_item_sales_id, name: 'INDEX_rb_billables_ON_line_item_sales_id'
    add_index :refinery_business_billables, :line_item_discount_id, name: 'INDEX_rb_billables_ON_line_item_discount_id'
    add_index :refinery_business_billables, :billed_company_id, name: 'INDEX_rb_billables_ON_billed_company_id'
    add_index :refinery_business_billables, :billed_invoice_id, name: 'INDEX_rb_billables_ON_billed_invoice_id'
    add_index :refinery_business_billables, :bill_happy_rabbit, name: 'INDEX_rb_billables_ON_bill_happy_rabbit'
  end

end
