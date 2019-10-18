Refinery::Authentication::Devise::User.class_eval do

  has_many :company_users, dependent: :destroy, class_name: 'Refinery::Business::CompanyUser'
  has_many :companies, through: :company_users, class_name: 'Refinery::Business::Company'

  scope :for_companies, -> (companies) { joins(:companies).where(Refinery::Business::Company.table_name => { id: Array(companies).map(&:id) }) }

  def projects
    Refinery::Business::Project.where(company_id: company_ids)
  end

  def label
    email
  end

  def self.find_by_label(label)
    find_by email: label
  end

  def self.to_source
    order(:email).pluck(:email).to_json.html_safe
  end

end
