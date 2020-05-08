require 'rack-flash'
class UserController < ApplicationController
  use Rack::Flash

  get '/signup' do
    erb :'/users/signup'
  end

  post '/signup' do
    if User.find_by(username: params[:username])
      flash[:message] = "Username already taken. Please try something else."
      redirect to '/signup'
    elsif User.find_by(email: params[:email])
      flash[:message] = "An account is already associated with that email address"
      redirect to '/signup'
    else 
      user = User.create(params)
      session[:id] = user.id
      redirect to '/main'
    end
  end

  get '/main' do
    current_user
    erb :'users/main_page'
  end

  post '/main' do
    list = List.create(params)
    current_user
    redirect to "/main"
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if !user
      flash[:message] = "There is no account associated with the username: #{params[:username]}"
      redirect to '/'
    elsif user && user.authenticate(params[:password])
      session[:id] = user.id
      redirect to '/main'
    else
      flash[:message] = "The username - password combination is incorrect"
      redirect to '/'
    end
  end

  post '/logout' do
    session.clear
    redirect to '/'
  end


end