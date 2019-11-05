
FactoryGirl.define do
  factory :shipment_parcel, class: Refinery::Shipping::ShipmentParcel do
    shipment
    description 'T-Shirts'
    #
    # # A factory that creates a Shipment with a courier that
    # # can be handled by EasyPost
    # factory :shipment_parcel_with_easypost do
    #   association :shipment, factory: :shipment_with_easypost
    #   weight 1 # Kg
    #
    #   length 100 # cm
    #   width 100  # cm
    #   height 50  # cm
    #
    #   # A factory to create associated with a shipment that has addresses
    #   # that makes the shipment an international shipment.
    #   factory :shipment_parcel_international do
    #     association :shipment, factory: :shipment_international
    #     contents_type ::Refinery::Shipping::ShipmentParcel::DEFAULT_CONTENTS_TYPES.first
    #     origin_country { |shipment_parcel| shipment_parcel.shipment.from_address.country }
    #     quantity 1 # pcs
    #     value 1 # USD
    #   end
    # end
  end
end

