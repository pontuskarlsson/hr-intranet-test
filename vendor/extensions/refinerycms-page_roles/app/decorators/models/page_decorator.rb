Refinery::Page.class_eval do

  # Associations
  has_many :page_roles, class_name: '::Refinery::PageRoles::PageRole', dependent: :destroy
  has_many :roles,      through: :page_roles, class_name: '::Refinery::Authentication::Devise::Role'

  def has_role?(title)
    raise ArgumentException, 'Role should be the title of the role not a role object.' if title.is_a?(::Refinery::Authentication::Devise::Role)
    roles.any?{ |r| r.title == title.to_s.camelize }
  end

  def user_authorized?(refinery_user)
    return true unless roles.exists?
    return false if refinery_user.nil?

    (role_ids & refinery_user.role_ids).any?
  end

  class << self

    def fast_access_menu(roles)
      live.in_menu.for_roles(roles).order(arel_table[:lft]).includes(:parent, :translations)
    end

    def for_roles(roles)
      includes(:page_roles).where(refinery_page_roles: { role_id: roles.map(&:id) << nil })
    end

    def find_authorized_by_link_url!(link_url, refinery_user = nil)
      find_by!(link_url: link_url).tap do |page|
        raise ::ActiveRecord::RecordNotFound unless page.user_authorized?(refinery_user)
      end
    end

  end

end
