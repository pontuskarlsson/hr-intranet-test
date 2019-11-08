Refinery::Authentication::Devise::User.class_eval do

  has_many :company_users, dependent: :destroy, class_name: 'Refinery::Business::CompanyUser'
  has_many :companies, through: :company_users, class_name: 'Refinery::Business::Company'

  configure_label :email

  scope :for_companies, -> (companies) { joins(:companies).where(Refinery::Business::Company.table_name => { id: Array(companies).map(&:id) }) }

  def projects
    Refinery::Business::Project.where(company_id: company_ids)
  end

end
