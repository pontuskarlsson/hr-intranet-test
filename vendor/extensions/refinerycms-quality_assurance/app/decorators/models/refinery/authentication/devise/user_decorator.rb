Refinery::Authentication::Devise::User.class_eval do

  has_many :has_inspected,    class_name: '::Refinery::QualityAssurance::Inspection', foreign_key: :inspected_by_id

  validates :topo_id,     uniqueness: true, allow_blank: true

  scope :has_inspected, -> (inspection) { where(id: inspection.inspected_by_id) }
  scope :company_inspections, -> (inspection) { where(id: inspection.inspected_by_id) }
  scope :for_meta, -> (h) {
    if h[:product_category].blank?
      where(nil)

    else
      case h[:product_category]
      when 'Socks' then where(email: ['sarahjh.griffiths@hunterboots.com', 'lauren.hawker@hunterboots.com', 'wati.lim@hunterboots.com'])
      when 'Bags' then where(email: ['phil.hall@hunterboots.com', 'levant.gemal@hunterboots.com', 'lauren.hawker@hunterboots.com', 'wati.lim@hunterboots.com'])
      else where(email: ['keely.duggan@hunterboots.com', 'lauren.hawker@hunterboots.com', 'wati.lim@hunterboots.com'])
      end
    end
  }
end
