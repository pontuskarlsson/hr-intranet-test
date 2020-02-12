Refinery::Authentication::Devise::User.class_eval do

  has_many :company_users, dependent: :destroy, class_name: 'Refinery::Business::CompanyUser'
  has_many :companies, through: :company_users, class_name: 'Refinery::Business::Company'
  has_many :purchases, foreign_key: :user_id,   class_name: 'Refinery::Business::Purchase', dependent: :nullify
  has_many :confirmed_plans, foreign_key: :confirmed_by_id, class_name: '::Refinery::Business::Plan'
  has_many :noticed_given_plans, foreign_key: :notice_given_by_id, class_name: '::Refinery::Business::Plan'

  configure_label :email

  scope :for_companies, -> (companies) { joins(:companies).where(Refinery::Business::Company.table_name => { id: Array(companies).map(&:id) }) }

  def projects
    Refinery::Business::Project.where(company_id: company_ids)
  end

end
