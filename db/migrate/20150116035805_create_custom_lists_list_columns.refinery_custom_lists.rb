# This migration comes from refinery_custom_lists (originally 2)
class CreateCustomListsListColumns < ActiveRecord::Migration

  def change
    create_table :refinery_custom_lists_list_columns do |t|
      t.integer :custom_list_id
      t.string :title
      t.string :column_type

      t.integer :position

      t.timestamps
    end

    add_index :refinery_custom_lists_list_columns, :custom_list_id
    add_index :refinery_custom_lists_list_columns, :position
  end

end
