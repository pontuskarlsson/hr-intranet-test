Refinery::Resource.class_eval do

  # Associations
  has_many :shipping_documents, class_name: '::Refinery::Shipping::Document', dependent: :nullify

end
