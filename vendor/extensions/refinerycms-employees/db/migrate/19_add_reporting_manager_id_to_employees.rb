class AddReportingManagerIdToEmployees < ActiveRecord::Migration

  def change
    add_column :refinery_employees, :reporting_manager_id, :integer
    add_index :refinery_employees, :reporting_manager_id
  end

end
