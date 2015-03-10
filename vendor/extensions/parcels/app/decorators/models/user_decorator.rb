Refinery::User.class_eval do

  # Associations
  has_many :received_parcels,     class_name: '::Refinery::Parcels::Parcel',    dependent: :nullify, foreign_key: :received_by_id
  has_many :assigned_parcels,     class_name: '::Refinery::Parcels::Parcel',    dependent: :nullify, foreign_key: :assigned_to_id
  has_many :addressed_to_parcels, class_name: '::Refinery::Parcels::Parcel',    dependent: :nullify, foreign_key: :to_user_id
  has_many :created_shipments,    class_name: '::Refinery::Parcels::Shipment',  dependent: :nullify, foreign_key: :created_by_id

  def parcels_user_attribute
    send(Refinery::Parcels.user_attribute_reference)
  end

end
