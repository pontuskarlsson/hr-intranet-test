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
      "#{portal}.happyrabbit.com:5000"
    end
  end

end
