Refinery::Authentication::Devise::User.class_eval do

  scope :for_role, -> (title) {
    joins(:roles).where(refinery_authentication_devise_roles: { title: title })
  }

end
