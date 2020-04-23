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

  scope :for_722, -> (h) {
    product_category, supplier_label = h[:product_category], h[:supplier_label]

    leadertek_users = where(arel_table[:email].matches("%@leadertek.cn"))

    if product_category == 'Bags'
      leadertek_users.or(where(email: %w(johan.astroem@fjallraven.se johanna.adner@fjallraven.se sara.gunnebjoerk@fjallraven.se)))

    else
      case supplier_label
      when 'Dongguan Manhattan Outdoor Clothing Co., Ltd', 'Yangzhou Jinquan Travelling Goods Co., Ltd' then leadertek_users.or(where(email: %w(emma.pettersson@fjallraven.se sara.gunnebjoerk@fjallraven.se)))
      else leadertek_users.or(where(email: %w(emma.pettersson@fjallraven.se sara.gunnebjoerk@fjallraven.se laura.awan@fjallraven.se maria.pettersson@fjallraven.se)))
      end
    end
  }
end
