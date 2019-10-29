class CreateBusinessCoupons < ActiveRecord::Migration

  def change
    create_table :refinery_business_coupons do |t|
      # t.string :code
      # t.string :name
      # t.string :invoice_name
      # t.text :description
      #
      # t.boolean :public, null: false, default: false
      # t.company_id :integer
      #
      # t.integer :article_id
      # t.decimal :article_base_amount, precision: 13, scale: 4
      # t.decimal :article_discount_amount, precision: 13, scale: 4
      # t.decimal :article_discount_percentage, precision: 9, scale: 6
      #
      # t.string :discount_type
      # t.decimal :discount_amount,     null: false, default: 0.0, precision: 13, scale: 4
      # t.decimal :discount_percentage, null: false, default: 0.0, precision: 9, scale: 6
      # t.string :currency_code
      #
      # t.string :duration_type
      # t.integer :duration_count
      # t.datetime :valid_till
      # t.integer :max_redemptions
      #
      # t.integer :redemptions
      #
      # t.string :apply_on
      #
      # t.string :plan_constraint
      # t.string :addon_constraint
      #
      # t.string :status
      # t.datetime :archived_at


      t.timestamps
    end

  end

end
