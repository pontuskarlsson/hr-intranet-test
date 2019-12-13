class WWWSubdomain

  def self.matches? request
    request.subdomain == www
  end

  def self.www
    if Rails.env.production?
      'www'
    else
      'www-dev'
    end
  end

end
