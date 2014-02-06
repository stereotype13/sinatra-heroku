require 'data_mapper'
#require 'dm-sqlite-adapter'
require 'bcrypt'
require 'securerandom'

configure :development do
    DataMapper.setup(:default, "sqlite:db.sqlite")
end

configure :production do
    DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_AQUA_URL'])
end

class User
  include DataMapper::Resource
  include BCrypt

  property :id, Serial, :key => true
  property :username, String, :length => 3..50
  property :password, BCryptHash
  
  def authenticate(attempted_password)
    if self.password == attempted_password
      true
    else
      false
    end
  end
  
  has 1, :session
  has n, :webapps
end

class Session
  include DataMapper::Resource
  
  belongs_to :user
  
  property :id, String, length: 344, key: true
  
  def initialize()
    self.id = SecureRandom.base64(16)
    #self.domain = nil
  end
  
end

class Webapp
  include DataMapper::Resource

  belongs_to :user, :required => false

  property :id, Serial, key: true
  property :webapp_key, String
  property :domain, String, length: 30

  def initialize()
    self.webapp_key = SecureRandom.base64(16)
    
  end

  has n, :events
end

class Event
   include DataMapper::Resource
   
   belongs_to :webapp, :required => false

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

users = User.all
users.each do |user|
  user.destroy
end

admin_user = User.new
admin_user.username = "admin"
admin_user.password = "admin"
admin_user.save