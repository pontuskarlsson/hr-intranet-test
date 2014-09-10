class AddAttributesToUser < ActiveRecord::Migration
  def change
    add_column :refinery_users, :title, :string
    add_column :refinery_users, :full_name, :string
    add_column :refinery_users, :profile_image_id, :integer

    add_index :refinery_users, :profile_image_id
  end
end
