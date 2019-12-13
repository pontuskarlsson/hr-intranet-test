class PortalSubdomain

  def self.matches? request
    request.subdomain == portal
  end

  def self.portal
    if Rails.env.production?
      'portal'
    else
      'portal-dev'
    end
  end

end
