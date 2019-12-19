Refinery::Authentication::Devise::User.class_eval do

  has_many :has_inspected,    class_name: '::Refinery::QualityAssurance::Inspection', foreign_key: :inspected_by_id

  validates :topo_id,     uniqueness: true, allow_blank: true

  scope :has_inspected, -> (inspection) { where(id: inspection.inspected_by_id) }
  scope :company_inspections, -> (inspection) { where(id: inspection.inspected_by_id) }
end
