require 'sinatra'

class Blocmetrics < Sinatra::Application
    get '/' do
      "Hello World!"
    end
    
    get '/test' do
      "This is another test."
    end
end

