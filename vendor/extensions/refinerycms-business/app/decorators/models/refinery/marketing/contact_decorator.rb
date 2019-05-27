Refinery::Marketing::Contact.class_eval do

  has_one :company, dependent: :nullify, class_name: 'Refinery::Business::Company'

end
