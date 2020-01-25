class WWWSubdomain

  def self.matches? request
    request.subdomain == www
  end

  def self.www
    ENV['SUBDOMAIN_PUBLIC']
  end

  def self.domain
    if Rails.env.production?
      "#{www}.happyrabbit.com"
    else
      "#{www}.happyrabbit.com:5000"
    end
  end

  def self.protocol
    if Rails.env.production?
      'https'
    else
      'http'
    end
  end

end
