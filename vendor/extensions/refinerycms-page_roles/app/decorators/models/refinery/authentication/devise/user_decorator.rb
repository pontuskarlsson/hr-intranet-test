Refinery::Authentication::Devise::User.class_eval do

  def authorized_for_page?(link_url)
    page = ::Refinery::Page.find_by link_url: link_url
    return false unless page.present?
    return true unless page.roles.exists?

    page.user_page_role_ids(self).any?
  end

end
