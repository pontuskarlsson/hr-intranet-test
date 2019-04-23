Refinery::Marketing::Contact.class_eval do

  # Associations
  has_many :shipment_accounts,  class_name: '::Refinery::Parcels::ShipmentAccount', dependent: :nullify, foreign_key: :contact_id
  has_many :from_shipments,     class_name: '::Refinery::Parcels::Shipment',        dependent: :nullify, foreign_key: :from_contact_id
  has_many :to_shipments,       class_name: '::Refinery::Parcels::Shipment',        dependent: :nullify, foreign_key: :to_contact_id
  has_many :parcels,            class_name: '::Refinery::Parcels::Parcel',          dependent: :nullify, foreign_key: :from_contact_id

end
