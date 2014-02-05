source 'https://rubygems.org'
gem 'sinatra'
gem 'rack'
gem 'data_mapper'
gem 'dm-sqlite-adapter'
gem 'bcrypt-ruby'
gem 'sinatra-flash'

group :production do
    gem "pg"
    gem "dm-postgres-adapter"
end

group :development, :test do
    gem "sqlite3"
    gem "dm-sqlite-adapter"
end
