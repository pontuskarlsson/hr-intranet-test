class PortalSubdomain

  def self.matches? request
    # Allow Railway domain or matching subdomain
    return true if ENV['RAILWAY_PUBLIC_DOMAIN'].present? && request.host == ENV['RAILWAY_PUBLIC_DOMAIN']
    request.subdomain == portal
  end

  def self.portal
    ENV['SUBDOMAIN_PORTAL']
  end

  def self.domain
    # Use Railway domain if set, otherwise use happyrabbit.com
    return ENV['RAILWAY_PUBLIC_DOMAIN'] if ENV['RAILWAY_PUBLIC_DOMAIN'].present?

    if Rails.env.production?
      "#{portal}.happyrabbit.com"
    else
      "#{portal}.happyrabbit.com:5005"
    end
  end

  def self.protocol
    if Rails.env.production?
      'https://'
    else
      'http://'
    end
  end

  def self.protocol_domain
    "#{protocol}#{domain}"
  end

end
