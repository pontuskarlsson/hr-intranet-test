class PortalSubdomain

  def self.matches? request
    request.subdomain == portal
  end

  def self.portal
    ENV['SUBDOMAIN_PORTAL']
  end

  def self.domain
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
