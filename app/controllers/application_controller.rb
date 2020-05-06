require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :index, :layout => :frontpage
  end

  helpers do
    def logged_in?
      !!session[:id]
    end

    def current_user 
      @current_user ||= User.find_by(id: session[:id])
    end
  
    def redirect_login
      if !logged_in?
        redirect to '/'
      end
    end

  end

end