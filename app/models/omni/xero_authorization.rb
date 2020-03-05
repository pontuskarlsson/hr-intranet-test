class Omni::XeroAuthorization < Omni::Authorization

  store :content, accessors: [ :tenant_id ], coder: JSON, prefix: :xero

  validates :tenant_id,     presence: true

  validate do
    errors.add(:omni_authentication_id, :invalid) unless omni_authentication&.provider == 'xero_oauth2'
    errors.add(:tenant_id, :invalid) unless available_tenant_ids.include? tenant_id
  end

  def available_tenant_ids
    Array(omni_authentication.extra.xero_tenants).map(&:tenantId)
  rescue StandardError
    []
  end

end
