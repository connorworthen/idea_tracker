require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

    get '/' do
    erb :root
  end

  get '/home' do
    authorize
    erb :home
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  helpers do
    def logged_in?
      !!User.find_by(id: session[:user_id])
    end

    def current_user
      user = User.find_by(id: session[:user_id])
      raise AuthenticationError if user.nil?

      user
    end

    def authenticate(username, password)
      user = User.find_by(username: username)
      raise AuthenticationError unless !!user
      raise AuthenticationError unless user.authenticate(password)

      session[:user_id] = user.id
      user
    end

    def authorize
      current_user
    end

    def authorize_user(idea)
      raise NoResourceError unless idea
      raise AuthorizationError if idea.user != current_user
    end

    def login_error_messages(errors)
      erb :'sessions/_errors', locals: { errors: errors } if errors
    end

    def own_idea?(idea)
      current_user == idea.user
    end
  end

  error AuthenticationError do
    status AuthenticationError.status
    erb :error, locals: { msg: AuthenticationError.msg, links: AuthenticationError.links }, layout: false
  end

  error AuthorizationError do
    status AuthorizationError.status
    erb :error, locals: { msg: AuthorizationError.msg, links: AuthorizationError.links }, layout: false
  end

  error NoResourceError do
    status NoResourceError.status
    erb :error, locals: { msg: NoResourceError.msg, links: NoResourceError.links }, layout: false
  end

  error PostSiteError do
    status PostSiteError.status
    erb :error, locals: { msg: PostSiteError.msg, links: PostSiteError.links }, layout: false
  end
end