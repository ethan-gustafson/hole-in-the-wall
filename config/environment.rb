require 'bundler'
Bundler.require

configure :development do
	set :database, {adapter: "sqlite3", database: 'sqlite3:db/hole-in-the-wall.db'}
end

require_all 'app'