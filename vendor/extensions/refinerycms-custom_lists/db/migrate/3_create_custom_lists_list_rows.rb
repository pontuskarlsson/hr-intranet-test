class CreateCustomListsListRows < ActiveRecord::Migration

  def change
    create_table :refinery_custom_lists_list_rows do |t|
      t.integer :custom_list_id

      t.integer :position

      t.timestamps
    end

    add_index :refinery_custom_lists_list_rows, :custom_list_id
    add_index :refinery_custom_lists_list_rows, :position
  end

end
