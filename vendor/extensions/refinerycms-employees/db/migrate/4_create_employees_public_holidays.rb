class CreateEmployeesPublicHolidays < ActiveRecord::Migration

  def up
    create_table :refinery_public_holidays do |t|
      t.integer :event_id
      t.string :title
      t.string :country
      t.date :holiday_date,           null: false
      t.boolean :half_day,            null: false, default: 0

      t.timestamps
    end

    add_index :refinery_public_holidays, :event_id
    add_index :refinery_public_holidays, :holiday_date
  end

  def down
    remove_index :refinery_public_holidays, :event_id
    remove_index :refinery_public_holidays, :holiday_date

    drop_table :refinery_public_holidays

  end

end
