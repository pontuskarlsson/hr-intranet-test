Refinery::Authentication::Devise::User.class_eval do

  # Associations
  has_one :contact, class_name: '::Refinery::Marketing::Contact', dependent: :nullify

  before_create do
    assign_contact
  end

  def assign_contact
    self.contact = ::Refinery::Marketing::Contact.find_by email: email
  end

end
