class Omni::Authentication < ApplicationRecord

  self.table_name = 'omni_authentications'

  serialize :auth_info, Hash
  serialize :extra, Hash

  belongs_to :user,                 class_name: '::Refinery::Authentication::Devise::User'

  has_many :omni_authorizations,    class_name: '::Omni::Authorization', foreign_key: :omni_authentication_id

  validates :user_id,         presence: true
  validates :provider,        presence: true, uniqueness: { scope: :user_id }
  validates :uid,             presence: true, uniqueness: { scope: :provider }

  def token_expired?(within = 1.second)
    system_time = Time.now.to_i
    system_time >= (token_expires - within).to_i
  end

end
