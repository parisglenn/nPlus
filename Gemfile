source 'https://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'thin'

gem 'devise'

group :development, :test do 
	gem 'sqlite3'
	gem 'better_errors'
	gem 'binding_of_caller'
  gem 'rspec-rails', '~>2.14.0'
  gem 'guard-rspec', require: false
  gem 'pry', '~> 0.9.12.6'
  gem 'hirb', '~> 0.7.1'
  gem 'database_cleaner'
  # gem 'capybara'
  # gem 'capybara-webkit'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'faker'
end

# Gems used only for assets and not required
# in production environments by default.
#group :assets do
  #gem 'sass-rails',   '~> 3.2.3'
  # gem 'coffee-rails', '~> 3.2.1'
	gem 'jquery-rails'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'bootstrap-datepicker-rails'
  gem 'uglifier', '>= 1.0.3'
#end

#group :assets do
  gem 'uglifier', '>= 1.0.3'
  #gem 'bootstrap-sass', '~> 2.2.2.0'
  gem "flat-ui-rails", "0.0.2"
  gem 'turbolinks', '1.1.1'
  gem "jquery-turbolinks", "~> 2.0.1"
  gem 'bootstrap-datepicker-rails'
  gem 'jquery-datatables-rails', git: 'git://github.com/rweng/jquery-datatables-rails.git'
#end

group :production do
  gem 'rails_12factor'
end

gem 'pg'
gem 'jquery-rails'
gem 'bootstrap-datepicker-rails'
gem 'chosen-rails'

gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails"

gem 'acts_as_commentable_with_threading'

gem 'simple_form'
gem "pony", "1.10"
gem "mail"
gem "icalendar"

# To use ActiveModel has_secure_password
 ######Why is this not loading? did version of ruby change or something?
 ################gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
ruby '2.0.0'