# This migration comes from refinery_contacts (originally 1)
class CreateContactsContacts < ActiveRecord::Migration

  def up
    create_table :refinery_contacts do |t|
      t.integer :base_id
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :city
      t.string :skype
      t.string :zip
      t.string :country
      t.string :title
      t.boolean :private
      t.integer :contact_id
      t.boolean :is_organisation
      t.string :mobile
      t.string :fax
      t.string :website
      t.string :phone
      t.string :description
      t.string :linked_in
      t.string :facebook
      t.string :industry
      t.string :twitter
      t.string :email
      t.string :organisation_name
      t.integer :organisation_id
      t.string :tags_joined_by_comma
      t.boolean :is_sales_account
      t.string :customer_status
      t.string :prospect_status
      t.datetime :base_modified_at
      t.text :custom_fields

      t.integer :position
      t.boolean :removed_from_base,   null: false, default: 0

      t.timestamps
    end

    add_index :refinery_contacts, :base_id
    add_index :refinery_contacts, :base_modified_at
    add_index :refinery_contacts, :organisation_id
    add_index :refinery_contacts, :removed_from_base

  end

  def down
    remove_index :refinery_contacts, :base_id
    remove_index :refinery_contacts, :base_modified_at
    remove_index :refinery_contacts, :organisation_id
    remove_index :refinery_contacts, :removed_from_base

    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-contacts"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/contacts/contacts"})
    end

    drop_table :refinery_contacts

  end

end
