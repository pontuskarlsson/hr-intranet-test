# This migration comes from refinery_page_roles (originally 1)
class CreatePageRolesPageRoles < ActiveRecord::Migration

  def up
    create_table :refinery_page_roles do |t|
      t.references :page
      t.references :role

      t.timestamps
    end
    add_index :refinery_page_roles, [:page_id, :role_id]
  end

  def down
    drop_table :refinery_page_roles
  end

end
