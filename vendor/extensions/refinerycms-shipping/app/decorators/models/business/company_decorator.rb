Refinery::Business::Company.class_eval do

  has_many :to_shipments,   through: :contact

end
