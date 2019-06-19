# encoding: utf-8
Refinery::Core.configure do |config|
  # When true will rescue all not found errors and display a friendly error page
  config.rescue_not_found = Rails.env.production?

  # When true this will force SSL redirection in all Refinery backend controllers.
  # config.force_ssl = false

  config.s3_backend = !(ENV['S3_KEY'].nil? || ENV['S3_SECRET'].nil?)
  config.s3_access_key_id =     ENV['S3_KEY']
  config.s3_secret_access_key = ENV['S3_SECRET']
  config.s3_bucket_name =       ENV['S3_BUCKET']
  config.s3_region =            ENV['S3_REGION']

  # Use a custom Dragonfly storage backend instead of the default
  # file system for storing resources and images
  # config.dragonfly_custom_backend_class = nil
  # config.dragonfly_custom_backend_opts = {}

  # Whenever Refinery caches anything and can set a cache key, it will add
  # a prefix to the cache key containing the string you set here.
  # config.base_cache_key = :refinery

  # Site name
  config.site_name = 'Happy Rabbit Portal'

  # This activates Google Analytics tracking within your website. If this
  # config is left blank or set to UA-xxxxxx-x then no remote calls to
  # Google Analytics are made.
  # config.google_analytics_page_code = "UA-xxxxxx-x"

  # Enable/disable authenticity token on frontend
  config.authenticity_token_on_frontend = true

  # Should set this if concerned about DOS attacks. See
  # http://markevans.github.com/dragonfly/file.Configuration.html#Configuration
  # config.dragonfly_secret = "e4c07b16cc3e896773fc03927e844adf8bd30091d3e4cee0"

  # Add extra tags to the wymeditor whitelist e.g. = {'tag' => {'attributes' => {'1' => 'href'}}} or just {'tag' => {}}
  # config.wymeditor_whitelist_tags = {}

  # Register extra javascript for backend
  # config.register_javascript "prototype-rails"

  # Register extra stylesheet for backend (optional options)
  # config.register_stylesheet "custom", :media => 'screen'
  config.register_stylesheet 'refinery/backend', :media => 'screen'

  # Specify a different backend path than the default of /refinery.
  # config.backend_route = "refinery"
  config.mounted_path = '/'
end
