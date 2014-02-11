require 'data_mapper'
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
  
  validates_uniqueness_of :username, message: "Sorry. That user name has already been taken. =("

  def authenticate(attempted_password)
    if self.password == attempted_password
      true
    else
      false
    end
  end
  
  has 1, :session, constraint: :destroy
  has n, :webapps, constraint: :destroy
end

class Session
  include DataMapper::Resource
  
  belongs_to :user
  
  property :id, String, length: 344, key: true
  
  def initialize()
    self.id = SecureRandom.base64(255)
    #self.domain = nil
  end
  
end

class Webapp
  include DataMapper::Resource

  belongs_to :user, :required => false

  property :id, Serial, key: true
  property :name, String
  property :webapp_key, String
  property :domain, String, length: 30

  def initialize()
    self.webapp_key = SecureRandom.base64(18)
    
  end

  has n, :events, constraint: :destroy
end

class Event
   include DataMapper::Resource
   
   belongs_to :webapp, :required => false

   property :id, Serial, key: true
   property :tag_id, String
   property :tag_type, String
   property :tag_html, String, length: 255
   property :url, String
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

sessions = Session.all
sessions.each do |session|
	session.destroy
end

admin_user = User.new
admin_user.username = "admin"
admin_user.password = "admin"
admin_user.save

webapp = Webapp.new
webapp.user = admin_user
webapp.name = "blocmetrics"
webapp.domain = "blocmetrics.com"
webapp.webapp_key = "1234"
webapp.save

10.times do 
  event = Event.new
  event.webapp = webapp
  #event.time_stamp = DateTime.now - Random.rand(0..5).days
  event.time_stamp = Time.now - Random.rand(0..5)*24*60*60
  event.save
end