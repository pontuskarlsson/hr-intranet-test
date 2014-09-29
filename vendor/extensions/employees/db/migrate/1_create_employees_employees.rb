class CreateEmployeesEmployees < ActiveRecord::Migration

  def up
    create_table :refinery_employees do |t|
      t.integer :user_id
      t.integer :profile_image_id
      t.string :employee_no
      t.string :full_name
      t.string :id_no
      t.string :title
      t.integer :position

      t.timestamps
    end

    add_index :refinery_employees, :user_id
    add_index :refinery_employees, :profile_image_id
    add_index :refinery_employees, :employee_no
    add_index :refinery_employees, :position

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => 'refinerycms-employees'})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => '/employees/employees'})
    end

    remove_index :refinery_employees, :user_id
    remove_index :refinery_employees, :profile_image_id
    remove_index :refinery_employees, :employee_no
    remove_index :refinery_employees, :position

    drop_table :refinery_employees

  end

end
