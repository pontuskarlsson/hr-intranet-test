Refinery::Business::Company.class_eval do
  include ActionDispatch::Routing::RouteSet::MountedHelpers

  has_many :omni_authorizations,    class_name: '::Omni::Authorization', dependent: :destroy

  def notifiable_path(target, key)
    refinery.business_company_path(self)
  end

  def printable_name
    name
  end

  def printable_group_name
    name
  end

end
