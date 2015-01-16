# This migration comes from refinery_custom_lists (originally 4)
class CreateCustomListsListCells < ActiveRecord::Migration

  def change
    create_table :refinery_custom_lists_list_cells do |t|
      t.integer :list_row_id
      t.integer :list_column_id
      t.string :value

      t.integer :position

      t.timestamps
    end

    add_index :refinery_custom_lists_list_cells, :list_row_id
    add_index :refinery_custom_lists_list_cells, :list_column_id
    add_index :refinery_custom_lists_list_cells, :value
  end

end
