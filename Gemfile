source 'https://rubygems.org'
ruby '2.0.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use postgresql as the database for Active Record
gem 'pg'
gem 'prawn'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'carrierwave'
gem 'activerecord-session_store', github: 'rails/activerecord-session_store'
gem 'delayed_job_active_record'
gem 'will_paginate', '~> 3.0'
gem 'jquery-turbolinks'
gem 'validates_timeliness', '~> 3.0'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'
gem 'devise'
gem 'cancancan', '~> 1.7'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
	gem "rspec-rails", "~> 2.14.0"
	gem "factory_girl_rails", "~> 4.2.1"
	gem "cucumber-rails", :require => false
end

group :test do
	gem "faker", "~> 1.1.2"
	gem "capybara", "~> 2.1.0"
	gem "database_cleaner", "~> 1.0.1"
	gem "launchy", "~> 2.3.0"
	gem "selenium-webdriver", "~> 2.39.0"
	gem 'simplecov', :require => false
end

group :production do
  gem 'rails_12factor'
end
# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
gem 'debugger', group: [:development, :test]
