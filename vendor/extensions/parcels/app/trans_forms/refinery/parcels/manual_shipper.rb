module Refinery
  module Parcels
    class ManualShipper < TransForms::FormBase
      set_main_model :shipment, proxy: { attributes: %w(tracking_number courier) }, class_name: '::Refinery::Parcels::Shipment'

      validates :shipment,          presence: true
      validates :tracking_number,   presence: true
      validates :courier,   presence: true

      transaction do
        shipment.tracking_number = tracking_number
        shipment.courier = courier
        shipment.status = 'manually_shipped'
        shipment.shipping_date = Date.today
        shipment.save!
      end

    end

  end
end
