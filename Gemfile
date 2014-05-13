source 'https://rubygems.org'
source "http://gems.github.com"

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Better memcached interface
gem 'dalli'

# Database interfaces
gem 'sqlite3'
gem 'mysql2'

gem 'shuber-sortable', :require => 'sortable'
gem 'rmagick', :require => 'RMagick'
gem 'thin'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'dynamic_form'
gem 'time_diff', '~> 0.2.2'

#jquer javascript libraries
gem 'jquery-ui-rails'
gem 'jquery-rails'

# Currently, websocket-rails 0.7.0 breaks sync between the threads horribly
gem 'websocket-rails', '0.6.2'

# For background stuff
gem 'daemon'
gem 'rrd-ffi', :require => 'rrd'

# Better caching
gem 'cashier'

group :development do
  gem "rails-erd"
end

# Code coverage report generator
gem 'simplecov', :require => false, :group => :test
# We do loads in after_commit callbacks so need to include them in tests
gem 'test_after_commit', :group => :test

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'
  gem "therubyracer", :require => 'v8'

  gem 'uglifier', '>= 1.0.3'
end


# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
