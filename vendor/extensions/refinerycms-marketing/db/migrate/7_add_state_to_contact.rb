class AddStateToContact < ActiveRecord::Migration

  def change
    add_column :refinery_contacts, :state, :string
    add_index :refinery_contacts, :state
  end

end
