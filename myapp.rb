require 'sinatra'
require './models'

class Blocmetrics < Sinatra::Base
    get '/' do
      "Hello World!"
    end
    
    get '/test' do
      "This is another test."
    end
    
    get '/events' do
        @events = Event.all
        erb :events
    end
end

