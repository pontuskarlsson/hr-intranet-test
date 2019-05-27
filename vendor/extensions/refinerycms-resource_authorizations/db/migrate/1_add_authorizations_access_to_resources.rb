class AddAuthorizationsAccessToResources < ActiveRecord::Migration

  def change
    add_column :refinery_resources, :authorizations_access, :string
    add_index :refinery_resources, :authorizations_access

    add_column :refinery_images, :authorizations_access, :string
    add_index :refinery_images, :authorizations_access
  end

end
