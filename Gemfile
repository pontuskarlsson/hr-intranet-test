source 'https://rubygems.org'
#ruby '2.3.4'

gem 'rails', '4.2.11'

gem 'mysql2'

# Gems used only for assets and not required
# in production environments by default.
gem 'sass', '3.7.3'
gem 'sass-rails',   '5.0.7'
gem 'coffee-rails', '4.2.2'

gem 'uglifier', '4.1.20'

gem 'jquery-rails', '4.3.3'
gem 'foundation-rails', '6.5.3.0'

# Background worker
gem 'daemons'
gem 'delayed_job_active_record', '4.1.3'
gem 'delayed_job', '4.1.5'

# Workaround for strange missing dependency behaviour
#gem 'eventmachine', '1.0.9.1' # Not needed anymore????

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Refinery CMS
gem 'refinerycms', '3.0.6'
gem 'refinerycms-authentication-devise', '1.0.4'
#gem 'refinerycms-news', '2.1.2'
gem 'refinerycms-news', github: 'refinery/refinerycms-news', branch: 'master'
gem 'refinerycms-page-images', '3.0.0'
gem 'refinerycms-acts-as-indexed', '3.0.0'
gem 'refinerycms-testing', '3.0.6'
gem 'refinerycms-wymeditor', '1.1.0'
gem 'refinerycms-calendar',     path: 'vendor/extensions'
gem 'refinerycms-marketing',    path: 'vendor/extensions'
gem 'refinerycms-business',     path: 'vendor/extensions'
gem 'refinerycms-parcels',      path: 'vendor/extensions'
gem 'refinerycms-employees',    path: 'vendor/extensions'
gem 'refinerycms-store',        path: 'vendor/extensions'
gem 'refinerycms-custom_lists', path: 'vendor/extensions'
gem 'refinerycms-page_roles',   path: 'vendor/extensions'

# Specify specific version to prevent deprecation messages from 5.1 version
gem 'globalize', '5.0.1'

# Needed for S3 storage
gem 'fog-aws'
gem 'dragonfly-s3_data_store'

gem 'rubyzip'

# Need for password expiration
gem 'devise_security_extension'
gem 'trans_forms', path: 'vendor/extensions'

# Workaround to get the latest version of xeroizer that is not available from rubygems yet
gem 'xeroizer', '2.16.5'

gem 'roo', '2.7.1'
gem 'spreadsheet', '1.1.7'
gem 'airtable', git: 'https://github.com/Airtable/airtable-ruby'

# Zendesk
gem 'zendesk_api', '1.17'

group :development do
  gem 'thin', '1.7.2'
  gem 'foreman', '0.78.0'
end

group :development, :test do
  gem 'pry', '0.12.2'
end

group :test do
  gem 'rspec-rails', '3.8.2'
  gem 'factory_girl_rails', '4.6.0', require: false
end
