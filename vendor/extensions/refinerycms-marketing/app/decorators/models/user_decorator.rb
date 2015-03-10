Refinery::User.class_eval do

  # Associations
  has_one :contact, class_name: '::Refinery::Marketing::Contact', dependent: :nullify

end
