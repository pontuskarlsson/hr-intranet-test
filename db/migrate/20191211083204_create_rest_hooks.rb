class CreateRestHooks < ActiveRecord::Migration[5.1]
  def change
    create_table :rest_hooks do |t|
      t.references :user
      t.string :event_name
      t.string :hook_url
      t.text :scope

      t.timestamps
    end
    add_index :rest_hooks, :event_name
    add_index :rest_hooks, :hook_url
  end
end
