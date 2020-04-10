require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(
	:adapter => "postgresql", 
	:database => 'hole-in-the-wall_development'
)

require_all 'app'