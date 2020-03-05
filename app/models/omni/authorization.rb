class Omni::Authorization < ApplicationRecord

  self.table_name = 'omni_authorizations'

  belongs_to :omni_authentication,  class_name: '::Omni::Authentication'
  belongs_to :company,              class_name: '::Refinery::Business::Company', optional: true
  belongs_to :account,              class_name: '::Refinery::Business::Account', optional: true

  validates :company_id,            uniqueness: { scope: :type }, allow_nil: true
  validates :account_id,            uniqueness: { scope: :type }, allow_nil: true

  validate do
    errors.add(:company_id, :missing) if company.nil? && account.nil?
  end

  scope :xero, -> { where(type: 'Omni::XeroAuthorization') }

end
