module Refinery
  module Shipping
    class ManualShipper < TransForms::FormBase
      set_main_model :shipment, proxy: { attributes: %w(tracking_number courier shipping_date) }, class_name: '::Refinery::Shipping::Shipment'

      validates :shipment,          presence: true
      validates :tracking_number,   presence: true
      validates :courier,   presence: true

      transaction do
        shipment.tracking_number = tracking_number
        shipment.courier = courier
        shipment.status = 'manually_shipped'
        shipment.shipping_date = shipping_date
        shipment.save!
      end

    end

  end
end
