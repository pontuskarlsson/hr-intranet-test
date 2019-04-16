class ChangeContactDescriptionToText < ActiveRecord::Migration

  def up
    change_column :refinery_contacts, :description, :text
  end

  def down
    change_column :refinery_contacts, :description, :string
  end

end
