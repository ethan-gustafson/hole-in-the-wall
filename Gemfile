source 'http://rubygems.org'

ruby '2.7.1'

gem 'sinatra'
gem 'thin'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'
gem 'activerecord', '~> 6.0', '>= 6.0.2.2', :require => 'active_record'
gem 'rake'
gem 'bcrypt'
gem 'require_all'

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'rack-test'
  gem 'database_cleaner'
end

group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'tux'
end

group :development, :production do
  gem 'shotgun'
end

group :production do
  gem 'pg'
end
