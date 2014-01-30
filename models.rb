require 'data_mapper'
require 'bcrypt'
require 'securerandom'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite:db.sqlite")

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