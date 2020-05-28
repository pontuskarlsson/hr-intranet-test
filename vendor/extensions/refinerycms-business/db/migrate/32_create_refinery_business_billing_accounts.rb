class CreateRefineryBusinessBillingAccounts < ActiveRecord::Migration[5.1]

  def change
    create_table :refinery_business_billing_accounts, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :company, foreign_key: { to_table: :refinery_business_companies }, index: { name: 'INDEX_rb_billing_accounts_ON_company_id' }

      t.string :name
      t.boolean :primary, default: false, null: false
      t.string :email_addresses

      t.jsonb :preferences

      t.timestamps
    end

    add_index :refinery_business_billing_accounts, :name
    add_index :refinery_business_billing_accounts, :primary
  end

end
