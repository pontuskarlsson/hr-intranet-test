Refinery::Marketing::Contact.class_eval do

  has_many :companies, dependent: :nullify, class_name: 'Refinery::Business::Company'

end
