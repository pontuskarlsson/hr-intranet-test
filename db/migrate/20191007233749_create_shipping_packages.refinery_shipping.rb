# This migration comes from refinery_shipping (originally 16)
class CreateShippingPackages < ActiveRecord::Migration

  def change
    create_table :refinery_shipping_packages do |t|
      t.integer :shipment_id
      t.string :name
      t.string :package_type, precision: 13, scale: 4
      t.decimal :total_packages, precision: 13, scale: 4

      t.string :length_unit
      t.decimal :package_length, precision: 13, scale: 4
      t.decimal :package_width, precision: 13, scale: 4
      t.decimal :package_height, precision: 13, scale: 4

      t.string :volume_unit
      t.decimal :package_volume, precision: 13, scale: 4

      t.string :weight_unit
      t.decimal :package_weight, precision: 13, scale: 4

      t.integer :package_order

      t.timestamps
    end

  end

end
