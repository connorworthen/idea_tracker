class ApplicationController < Sintra::Base
  configure do
    set :views, 'app/views'
    set :public_folder, 'public'
    enable :sessions
    set :sessions, ENV['SESSION_SECRET']
    set :show_exceptions, false
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
    raise AuthenticationError unless !!user.authenticate(password)
  end

  def authorize
    current_user
  end
end



