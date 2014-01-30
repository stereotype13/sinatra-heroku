require 'sinatra'

class Blocmetrics < Sinatra::Base
    get '/' do
      "Hello World!"
    end
    
    get '/test' do
      "This is another test."
    end
end

