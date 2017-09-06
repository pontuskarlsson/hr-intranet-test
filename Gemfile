source 'https://rubygems.org'
ruby '2.1.10'

gem 'rails', '3.2.17'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

# Makes sure we can mirror the Heroku environment
gem 'foreman'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass', '3.2.13'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'foundation-rails', '~> 5.2'

# Background worker
gem 'daemons'
gem 'delayed_job_active_record', '~> 4.0'
gem 'delayed_job', '~> 3.0.5'

# Workaround for strange missing dependency behaviour
gem 'eventmachine', '1.0.9.1'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

# Refinery CMS
gem 'refinerycms', '~> 2.1.0'
gem 'refinerycms-news', '~> 2.1.0'
gem 'refinerycms-page-images', '~> 2.1.0'
gem 'refinerycms-acts-as-indexed', '~> 1.0.0'
gem 'refinerycms-calendar',     path: 'vendor/extensions'
gem 'refinerycms-marketing',    path: 'vendor/extensions'
gem 'refinerycms-business',     path: 'vendor/extensions'
gem 'refinerycms-parcels',      path: 'vendor/extensions'
gem 'refinerycms-employees',    path: 'vendor/extensions'
gem 'refinerycms-store',        path: 'vendor/extensions'
gem 'refinerycms-custom_lists', path: 'vendor/extensions'
gem 'refinerycms-page_roles',   path: 'vendor/extensions'

# Needed for S3 storage
gem 'fog'

# Need for password expiration
gem 'devise_security_extension'
gem 'trans_forms', path: 'vendor/extensions'

group :development, :test do
  gem 'pry'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails'
end

# Workaround to get the latest version of xeroizer that is not available from rubygems yet
gem 'xeroizer', '~> 2.16'
