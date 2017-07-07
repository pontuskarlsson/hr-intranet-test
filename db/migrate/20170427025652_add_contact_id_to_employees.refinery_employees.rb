# This migration comes from refinery_employees (originally 20)
class AddContactIdToEmployees < ActiveRecord::Migration

  def change
    add_column :refinery_employees, :contact_id, :integer
    add_index :refinery_employees, :contact_id
  end

end
