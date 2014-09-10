class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.references :expense_claim,    null: false
      t.references :contact,          null: false
      t.string :guid,                 null: false, default: ''
      t.string :reference,            null: false, default: ''
      t.string :status,               null: false, default: 'Not-Submitted'
      t.string :line_amount_types,    null: false, default: ''
      t.decimal :sub_total,           null: false, default: 0
      t.decimal :total,               null: false, default: 0
      t.date :date
      t.references :user,             null: false

      t.timestamps
    end
    add_index :receipts, :expense_claim_id
    add_index :receipts, :guid
    add_index :receipts, :status
    add_index :receipts, :user_id
    add_index :receipts, :contact_id
  end
end
