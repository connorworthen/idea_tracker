require 'rack-flash'
class UserController < ApplicationController
  use Rack::Flash

   get '/signup' do
    erb :'/users/signup', :layout => :frontpage
  end

  post '/signup' do
    if User.find_by(params[:username])
      flash[:message] = "Username has already been taken. Please try again."
      redirect '/signup'
    elsif User.find_by(params[:email])
      flash[:message] = "Email is already associated with an account."
      redirect '/signup'
    else 
      user = User.create(params)
      session[:id] = user.id
      redirect '/main'
    end
  end

  get '/main' do
    current_user
    erb :'/users/main_page'
  end

  post '/main' do
    list = List.create(params)
    current_user
    redirect '/main'
  end

  post '/login' di
    user = User.find_by(params[:username])
      if !User
      flash[:message] = "There is no account found with the username: #{params[:username]}"
      redirect to '/'
    elsif user && user.authenticate(params[:password])
      session[:id] = user.id
      redirect to '/main'
    else
      flash[:message] = "The username or password is incorrect. Please try again."
      redirect to '/'
    end
  end

  post '/logout' do
    session.clear
    redirect to '/'
  end


end