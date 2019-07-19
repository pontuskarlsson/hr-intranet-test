Refinery::Authentication::Devise::User.class_eval do

  has_many :inspections,  class_name: '::Refinery::QualityAssurance::Inspection'

  validates :topo_id,     uniqueness: true, allow_blank: true

end
