class OauthSignUpForm < ApplicationTransForm

  DEFAULT_ROLE_TITLES = [
      Refinery::Business::ROLE_EXTERNAL,
      Refinery::QualityAssurance::ROLE_EXTERNAL,
  ].freeze

  attr_accessor :user, :auth_hash

  validates :auth_hash,     presence: true

  transaction do
    self.user = Refinery::Authentication::Devise::User.create!(
        first_name: first_name,
        last_name: last_name,
        email: auth_hash.info&.email,
        password: password,
        password_confirmation: password
    )

    user.omni_authentications.create!(
        provider: auth_hash.provider,
        uid: auth_hash.uid,
        token: auth_hash.credentials.token,
        token_expires: auth_hash.credentials.expires_at,
        refresh_token: auth_hash.credentials.refresh_token,
        auth_info: auth_hash.info,
        extra: auth_hash.extra
    )

    default_roles.each do |role|
      user.roles_users.create!(role_id: role.id)
    end
  end

  private

  def first_name
    if auth_hash.info&.first_name.present?
      auth_hash.info.first_name

    elsif auth_hash.info&.name.present?
      auth_hash.info.name.split(' ')[0]
    end
  end

  def last_name
    if auth_hash.info&.last_name.present?
      auth_hash.info.last_name

    elsif auth_hash.info&.name.present?
      auth_hash.info.name.split(' ')[1..-1].join ' '
    end
  end

  def password
    @password ||= SecureRandom.hex
  end

  def default_roles
    @roles ||= Refinery::Authentication::Devise::Role.where(title: DEFAULT_ROLE_TITLES)
  end

end
