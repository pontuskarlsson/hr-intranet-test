
FactoryGirl.define do
  factory :shipment, :class => Refinery::Shipping::Shipment do
    association :created_by,  factory: :user
    assigned_to { |shipment| shipment.created_by }
    association :from_address, factory: :shipment_address
    association :to_address, factory: :shipment_address
    bill_to ::Refinery::Shipping::Shipment::BILL_TO.first

    # A factory that creates a Shipment with a courier that
    # can be handled by EasyPost
    factory :shipment_with_easypost do
      courier_company_label ::Refinery::Shipping::Shipment::COURIERS.detect { |_,v| v[:easypost] }[0]

      # A factory to create associated with addresses that makes the shipment
      # an international shipment.
      factory :shipment_international do
        from_address { FactoryGirl.create(:shipment_address, country: 'HK') }
        to_address { FactoryGirl.create(:shipment_address, country: 'US') }
      end
    end

    # A Factory that includes hashes of Rates as if returned
    # by the EasyPost api.
    factory :shipment_with_rates do
      sequence(:easypost_object_id) { |n| "shipment_abcde#{n}" }

      sequence(:rates_content) { |n| n.times.map { |n|
        { id: "rate_qwerty#{n}",
          object: 'Rate',
          mode: 'Test',
          carrier: ::Refinery::Shipping::Shipment::COURIER_DHL,
          service: 'SomeDeliveryService',
          currency: 'HKD',
          rate: '500',
          delivery_days: 1,
          carrier_account_id: 'ca_123456789'
        }
      } }
    end
  end
end

