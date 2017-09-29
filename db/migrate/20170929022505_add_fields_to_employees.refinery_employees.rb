# This migration comes from refinery_employees (originally 21)
class AddFieldsToEmployees < ActiveRecord::Migration

  def change
    add_column :refinery_employees, :emergency_contact, :string
    add_column :refinery_employees, :birthday, :date
    add_index :refinery_employees, :birthday
  end

end
