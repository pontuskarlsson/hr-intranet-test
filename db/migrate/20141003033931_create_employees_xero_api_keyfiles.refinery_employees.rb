# This migration comes from refinery_employees (originally 12)
class CreateEmployeesXeroApiKeyfiles < ActiveRecord::Migration

  def up
    create_table :refinery_xero_api_keyfiles do |t|
      t.string :organisation
      t.text :key_content

      t.timestamps
    end

    add_index :refinery_xero_api_keyfiles, :organisation
  end

  def down
    remove_index :refinery_xero_api_keyfiles, :organisation

    drop_table :refinery_xero_api_keyfiles

  end

end
