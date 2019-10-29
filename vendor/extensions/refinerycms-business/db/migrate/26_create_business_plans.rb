class CreateBusinessPlans < ActiveRecord::Migration

  def change
    create_table :refinery_business_plans do |t|
      # t.string :title
      # t.text :description
      # t.boolean :public, null: false, default: false
      # t.company_id :integer
      #
      # t.integer :article_id
      # t.string :interval
      # t.integer :interval_count

      t.timestamps
    end

  end

end
