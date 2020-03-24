class CreateMarketingLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :refinery_marketing_links do |t|
      t.integer :contact_id
      t.integer :linked_id
      t.string :linked_type
      t.string :relation
      t.string :title
      t.datetime :from
      t.datetime :to

      t.timestamps
    end
    add_index :refinery_marketing_links, :contact_id, name: 'INDEX_rm_links_ON_contact_id'
    add_index :refinery_marketing_links, [:linked_id, :linked_type], name: 'INDEX_rm_links_ON_linked_id_AND_linked_type'
    add_index :refinery_marketing_links, :linked_type, name: 'INDEX_rm_links_ON_linked_type'
    add_index :refinery_marketing_links, :relation, name: 'INDEX_rm_links_ON_relation'
    add_index :refinery_marketing_links, :title, name: 'INDEX_rm_links_ON_title'
    add_index :refinery_marketing_links, :from, name: 'INDEX_rm_links_ON_from'
    add_index :refinery_marketing_links, :to, name: 'INDEX_rm_links_ON_to'
  end
end
