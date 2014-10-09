source 'https://rubygems.org'
ruby '2.1.1'

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
gem 'refinerycms-calendar', path: 'vendor/extensions'
gem 'refinerycms-acts-as-indexed', '~> 1.0.0'
gem 'refinerycms-brands', path: 'vendor/extensions'
gem 'refinerycms-sales_orders', path: 'vendor/extensions'

# Needed for S3 storage
gem 'fog'

# Need for password expiration
gem 'devise_security_extension'

gem 'xeroizer', git: 'https://github.com/waynerobinson/xeroizer.git'
gem 'trans_forms', git: 'https://github.com/dannemanne/trans_forms.git'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'pry'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails'
end

gem 'refinerycms-contacts', :path => 'vendor/extensions'
gem 'refinerycms-parcels', :path => 'vendor/extensions'
gem 'refinerycms-employees', :path => 'vendor/extensions'