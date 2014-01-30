require 'data_mapper'
require 'bcrypt'
require 'securerandom'

configure :development do
    DataMapper.setup(:default, "sqlite:db.sqlite")
end

configure :production do
    DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_AQUA_URL'])
end

class Event
   include DataMapper::Resource
   
   property :id, Serial, key: true
   property :parameter_1, String
   property :parameter_2, String
   property :time_stamp, DateTime
   
   def initialize()
      self.time_stamp = DateTime.now 
    end
end

DataMapper.finalize
DataMapper.auto_upgrade!