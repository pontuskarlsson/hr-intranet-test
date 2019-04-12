Refinery::Authentication::Devise::User.class_eval do

  has_many :company_users, dependent: :destroy, class_name: 'Refinery::Business::CompanyUser'
  has_many :companies, through: :company_users, class_name: 'Refinery::Business::Company'

end
