class InviteForm < ApplicationTransForm

  DEFAULT_ROLE_TITLES = [
      Refinery::Business::ROLE_EXTERNAL,
      Refinery::QualityAssurance::ROLE_EXTERNAL,
  ].freeze

  attribute :first_name,    String
  attribute :last_name,     String
  attribute :email,         String
  attribute :company_role,  String

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :company, presence: true
  validates :current_user, presence: true
  validates :company_role, inclusion: ::Refinery::Business::CompanyUser::ROLES, allow_blank: true

  attr_accessor :company, :company_user, :user

  def model=(model)
    self.company = model
  end

  transaction do
    self.user = Refinery::Authentication::Devise::User.invite!(user_params, current_user)  do |u|
      u.set_default_attributes!
      u.skip_invitation = true
    end

    raise ActiveRecord::RecordInvalid, self unless user.persisted?

    default_roles.each do |role|
      user.roles_users.create!(role_id: role.id)
    end

    self.company_user = company.company_users.create!(user_id: user.id, role: company_role)

    user.delay.invite!(current_user)
  end

  private

  def user_params(allowed = %i(first_name last_name email))
    attributes.slice(*allowed)
  end

  def default_roles
    @roles ||= Refinery::Authentication::Devise::Role.where(title: DEFAULT_ROLE_TITLES)
  end

end
