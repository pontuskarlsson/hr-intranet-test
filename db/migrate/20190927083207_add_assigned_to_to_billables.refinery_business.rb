# This migration comes from refinery_business (originally 17)
class AddAssignedToToBillables < ActiveRecord::Migration

  def change
    add_column :refinery_business_billables, :assigned_to_id, :integer
    add_column :refinery_business_billables, :assigned_to_label, :string
    add_index :refinery_business_billables, :assigned_to_id, name: 'INDEX_rb_billables_ON_assigned_to_id'
    add_index :refinery_business_billables, :assigned_to_label, name: 'INDEX_rb_billables_ON_assigned_to_label'
  end

end
