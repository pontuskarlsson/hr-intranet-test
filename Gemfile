source 'https://rubygems.org'
#ruby '2.3.4'

gem 'rails', '5.1.7'
gem 'i18n', '~> 0.7'

gem 'mysql2'

gem 'uglifier', '4.1.20'

gem 'jquery-rails', '4.3.3'
gem 'foundation-rails', '6.5.3.0'
gem 'chartkick'

# Background worker
gem 'daemons'
gem 'delayed_job_active_record', '4.1.4'

# To use Jbuilder templates for JSON
gem 'jbuilder'

# Refinery CMS
gem 'refinerycms', '4.0.2'
gem 'refinerycms-authentication-devise', '~> 2.0.0'
gem 'refinerycms-news'
gem 'refinerycms-blog', github: 'refinery/refinerycms-blog', ref: '684036e9efbea667b286a850e5028d3a53b578bf'
# gem 'refinerycms-news', github: 'refinery/refinerycms-news', branch: 'master'
gem 'refinerycms-page-images'
gem 'refinerycms-acts-as-indexed'
gem 'refinerycms-testing'
gem 'refinerycms-wymeditor'
gem 'refinerycms-addons',       path: 'vendor/extensions'
gem 'refinerycms-calendar',     path: 'vendor/extensions'
gem 'refinerycms-marketing',    path: 'vendor/extensions'
gem 'refinerycms-business',     path: 'vendor/extensions'
gem 'refinerycms-shipping',     path: 'vendor/extensions'
gem 'refinerycms-employees',    path: 'vendor/extensions'
gem 'refinerycms-custom_lists', path: 'vendor/extensions'
gem 'refinerycms-page_roles',   path: 'vendor/extensions'
gem 'refinerycms-resource_authorizations', path: 'vendor/extensions'
gem 'refinerycms-quality_assurance', path: 'vendor/extensions'

# Invitable
gem 'devise_invitable', '2.0.1'

# OAuth
gem 'doorkeeper'

# Specify specific version to prevent deprecation messages from 5.1 version
gem 'globalize', '5.1.0'

# Needed for S3 storage
gem 'fog-aws'
gem 'dragonfly-s3_data_store'

gem 'rubyzip'
gem 'wicked_pdf', '1.1.0'
gem 'wkhtmltopdf-binary'

# Need for password expiration
#gem 'devise_security_extension'

gem 'trans_forms', path: 'vendor/extensions'

# Workaround to get the latest version of xeroizer that is not available from rubygems yet
gem 'xeroizer', '2.20.0'

gem 'roo', '2.7.1'
gem 'spreadsheet', '1.1.7'
gem 'airtable', git: 'https://github.com/Airtable/airtable-ruby'

# Zendesk
gem 'zendesk_api', '1.17'

# Notifications
gem 'activity_notification'

group :development do
  gem 'listen', '~> 3.0'
  gem 'thin', '1.7.2'
  gem 'foreman', '0.78.0'
end

group :development, :test do
  gem 'pry', '0.12.2'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'rspec-its' # for the model's validation tests.
end
