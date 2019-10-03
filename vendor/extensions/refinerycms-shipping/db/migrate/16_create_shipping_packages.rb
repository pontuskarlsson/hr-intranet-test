class CreateShippingPackages < ActiveRecord::Migration

  def change
    create_table :refinery_shipping_packages do |t|


      t.timestamps
    end

  end

end
