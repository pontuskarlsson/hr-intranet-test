Refinery::Page.class_eval do

  attr_accessor :authenticated_user

  # Associations
  has_many :page_roles, class_name: '::Refinery::PageRoles::PageRole', dependent: :destroy
  has_many :roles,      through: :page_roles, class_name: '::Refinery::Authentication::Devise::Role'

  def has_role?(title)
    raise ArgumentException, 'Role should be the title of the role not a role object.' if title.is_a?(::Refinery::Authentication::Devise::Role)
    roles.any?{ |r| r.title == title.to_s.camelize }
  end

  def user_authorized?(current_refinery_user)
    return true unless roles.exists?
    return false if current_refinery_user.nil?

    user_page_role_ids(current_refinery_user).any?
  end

  def user_page_role_ids(current_refinery_user)
    @user_page_role_ids ||= {}
    @user_page_role_ids[current_refinery_user.id] ||= (role_ids & current_refinery_user.role_ids)
  end

  def user_page_role_titles(current_refinery_user = authenticated_user)
    Refinery::Authentication::Devise::Role.where(id: user_page_role_ids(current_refinery_user)).pluck(:title)
  end

  class << self

    def fast_access_menu(roles)
      live.in_menu.for_roles(roles).order(arel_table[:lft]).includes(:parent, :translations)
    end

    def for_roles(roles)
      includes(:page_roles).where(refinery_page_roles: { role_id: roles.map(&:id) << nil })
    end

    def find_authorized_by_link_url!(link_url, current_refinery_user = nil)
      find_by!(link_url: link_url).tap do |page|
        raise ::ActiveRecord::RecordNotFound unless page.user_authorized?(current_refinery_user)
        page.authenticated_user = current_refinery_user
      end
    end

  end

end
