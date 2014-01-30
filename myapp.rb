require 'sinatra'
require './models'

class Blocmetrics < Sinatra::Base
    get '/' do
      "Hello World!"
    end
    
    get '/test' do
      "This is another test."
    end
    
    get '/event' do
      erb :event    
    end
    
    get '/events' do
        @events = Event.all
        erb :events
    end
    
    post '/event/data' do
		@event = Event.new
		@event.parameter_1 = params[:parameter_1]
		@event.parameter_2 = params[:parameter_2]
		@event.save
	end
end

