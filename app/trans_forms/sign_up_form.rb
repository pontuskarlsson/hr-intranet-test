class SignUpForm < ApplicationTransForm

  DEFAULT_ROLE_TITLES = [
      Refinery::Business::ROLE_EXTERNAL,
      Refinery::QualityAssurance::ROLE_EXTERNAL,
  ].freeze

  attribute :company_name, String
  attribute :full_name, String
  attribute :email, String
  attribute :password, String
  attribute :password_confirmation, String

  validates :company_name, presence: true
  validates :full_name, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true

  attr_accessor :user, :company

  validate do
    if password != password_confirmation
      errors.add(:password_confirmation, :does_not_match)
    end
    if Refinery::Business::Company.where(name: company_name).exists?
      errors.add(:company_name, :not_allowed)
    end
  end

  transaction do
    self.user = Refinery::Authentication::Devise::User.create!(user_params)

    all_errors_to(:company_name) do
      self.company = Refinery::Business::Company.create!(company_params)
    end

    company.company_users.create!(user: user, role: 'Owner')

    default_roles.each do |role|
      user.roles_users.create!(role_id: role.id)
    end
  end

  private

  def user_params
    attributes.slice(:full_name, :email, :password, :password_confirmation)
  end

  def company_params
    { name: company_name }
  end

  def default_roles
    @roles ||= Refinery::Authentication::Devise::Role.where(title: DEFAULT_ROLE_TITLES)
  end

end
