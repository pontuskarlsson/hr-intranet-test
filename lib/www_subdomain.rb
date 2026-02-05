class WWWSubdomain

  def self.matches? request
    # Allow Railway domain or matching subdomain
    return true if ENV['RAILWAY_PUBLIC_DOMAIN'].present? && request.host == ENV['RAILWAY_PUBLIC_DOMAIN']
    request.subdomain == www
  end

  def self.www
    ENV['SUBDOMAIN_PUBLIC']
  end

  def self.domain
    # Use Railway domain if set, otherwise use happyrabbit.com
    return ENV['RAILWAY_PUBLIC_DOMAIN'] if ENV['RAILWAY_PUBLIC_DOMAIN'].present?

    if Rails.env.production?
      "#{www}.happyrabbit.com"
    else
      "#{www}.happyrabbit.com:5005"
    end
  end

  def self.protocol
    if Rails.env.production?
      'https'
    else
      'http'
    end
  end

  def self.host
    "#{protocol}://#{domain}"
  end

end
