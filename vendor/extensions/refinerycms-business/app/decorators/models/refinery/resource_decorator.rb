Refinery::Resource.class_eval do

  has_many :business_documents, dependent: :nullify, class_name: 'Refinery::Business::Document'

end
