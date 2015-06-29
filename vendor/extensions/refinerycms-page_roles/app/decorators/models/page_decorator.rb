Refinery::Page.class_eval do

  # Associations
  has_many :page_roles, class_name: '::Refinery::PageRoles::PageRole', dependent: :destroy
  has_many :roles,      through: :page_roles

  def has_role?(title)
    raise ArgumentException, 'Role should be the title of the role not a role object.' if title.is_a?(::Refinery::Role)
    roles.any?{ |r| r.title == title.to_s.camelize }
  end

  def user_authorized?(refinery_user)
    return true unless roles.exists?
    return false if refinery_user.nil?

    user_roles = refinery_user.roles.select(:title).map(&:title)
    roles.any?{ |r| user_roles.include?(r.title) }
  end

  class << self

    def fast_access_menu(roles)
      live.in_menu.for_roles(roles).order(arel_table[:lft]).includes(:parent, :translations)
    end

    def for_roles(roles)
      includes(:page_roles).where(refinery_page_roles: { role_id: roles.map(&:id) << nil })
    end

  end

end
