require 'sinatra'
require 'sinatra/flash'
require './models'

class Blocmetrics < Sinatra::Base
    register Sinatra::Flash
    enable :sessions

    helpers do

        def authorize(username, password)
          user = User.first(:username => username)
          p user.username
          p user.password
          if !user.nil? && user.authenticate(password)
            #user is authenticated, so let's create a session
            session = Session.new
            session.user = user
            session.save

            #set the session cookie
            response.set_cookie "session_token", {value: session.id, path: '/'}

            true
          else
            false
          end

        end

        def current_user
          session = Session.first(request.cookies["session_token"])
          if !session.nil?
            session.user
          else
            nil
          end
        end
    end


    get '/' do
      erb :welcome
    end
    
    get '/login' do
      erb :login
    end

    get '/users' do
      @users = User.all  
      erb :users
    end

    get '/sign_up' do
      @user = User.new  
      erb :sign_up
    end

    post '/users/new' do
      @user = User.new
      password = params[:password]
      confirm_password = params[:confirm_password]

      if password == confirm_password
        @user.username = params[:username]
        @user.password = password
        @user.save
        flash[:success] = "You've signed up successfully."
        redirect to('/')
        
      else
        redirect to('/sign_up')
      end

    end

    post '/login/auth' do
      username = params[:username]
      password = params[:password]

      if authorize(username, password)
        flash[:success] = "Welcome, #{username}."
        redirect to('/')
      else
        flash[:error] = "Couldn't find username and/or password."
        redirect to('/login')
      end

    end

    get '/auth/logout' do
      session = Session.first(:user => current_user)
      session.destroy
      current_user = nil
      flash[:success] = "Successfully signed out."
      redirect to('/')
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

