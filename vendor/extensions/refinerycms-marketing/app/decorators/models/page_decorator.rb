Refinery::Page.class_eval do

  # Associations
  has_one :landing_page,  class_name: '::Refinery::Marketing::LandingPage',
                          dependent: :destroy

end
