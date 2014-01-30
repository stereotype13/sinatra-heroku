require 'sinatra'

class Blocmetrics < Sinatra::Base
    get '/' do
      "Hello World!"
    end
end

Blocmetrics.run!