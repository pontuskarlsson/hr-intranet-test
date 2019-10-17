Refinery::Business::Company.class_eval do

  has_many :to_shipments,         through: :contact

  has_many :shipper_shipments,    class_name: '::Refinery::Shipping::Shipment', foreign_key: 'shipper_company_id',   dependent: :nullify
  has_many :receiver_shipments,   class_name: '::Refinery::Shipping::Shipment', foreign_key: 'receiver_company_id',  dependent: :nullify
  has_many :consignee_shipments,  class_name: '::Refinery::Shipping::Shipment', foreign_key: 'consignee_company_id', dependent: :nullify
  has_many :supplier_shipments,   class_name: '::Refinery::Shipping::Shipment', foreign_key: 'supplier_company_id',  dependent: :nullify
  has_many :forwarder_shipments,  class_name: '::Refinery::Shipping::Shipment', foreign_key: 'forwarder_company_id', dependent: :nullify
  has_many :courier_shipments,    class_name: '::Refinery::Shipping::Shipment', foreign_key: 'courier_company_id',   dependent: :nullify

end
