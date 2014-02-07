require 'sinatra'
require 'sinatra/flash'
require './models'

class Blocmetrics < Sinatra::Application
    register Sinatra::Flash
    enable :sessions

    helpers do

        def authorize(username, password)
          user = User.first(:username => username)
         
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
          session = Session.first(id: request.cookies["session_token"])
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

        if @user.save
          flash[:success] = "You've signed up successfully."
          redirect to('/')
        else
          output = ""
          @user.errors.each do |error|
            output = output + error + '<br>'
          end
          flash[:error] = output
          redirect '/sign_up'
        end
        
        
        
      else
        redirect '/sign_up'
      end

    end

    post '/login/auth' do
      username = params[:username]
      password = params[:password]

      if authorize(username, password)
        flash[:success] = "Welcome, #{username}."
        redirect '/'
      else
        flash[:error] = "Couldn't find username and/or password."
        redirect '/login'
      end

    end

    get '/auth/logout' do
      session = Session.first(:user => current_user)
      session.destroy
      current_user = nil
      response.delete_cookie "session_token"
      flash[:success] = "Successfully signed out."
      redirect '/'
    end
    
    get '/webapps' do
      if current_user
        @webapps = Webapp.all(user: current_user)
        erb :webapps
      else
        "You must be logged in to do that."
      end
    end

    get '/webapps/new' do
      if current_user
        erb :new_webapp
      else
        "You must be logged in to do that."
      end
      
    end

    post '/webapps/create' do

      if current_user
        @webapp = Webapp.new
        @webapp.user = current_user
        @webapp.domain = params[:domain]
		@webapp.name = params[:name]
        if @webapp.save
          flash[:success] = "Webapp registered successfully."
          redirect '/'
        else
          flash[:error] = "There was a problem registering your webapp."
          redirect '/webapps/new'
        end
      else
        "You must be logged in to do that."
      end
      
    end

	get '/webapps/:id/events' do
		if current_user
		  if @webapp = Webapp.first(user: current_user, id: params[:id])
			@events = @webapp.events
			erb :events
		  else
			"There was a problem finding your web application."
		  end
		else
		  "You must be logged in to do that."
		end
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

