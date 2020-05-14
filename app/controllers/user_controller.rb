require 'rack-flash'
class UserController < ApplicationController
  use Rack::Flash
  
  get '/users' do
    @users = User.all
    erb :'users/show.html'
  end

  post '/users' do
    @user = User.create(username: params[:username], password: params[:password])
    if @user.errors.any?
      @errors = @user.errors.messages
      erb :'/users/signup'
    else
      session[:user_id] = @user.id
      redirect '/users'
    end
  end

  get '/users/:id' do
    @user = User.find_by(id: params[:id])
    erb :'users/show.html'
  end

  get "/signup" do
    erb :"/users/signup"
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
      redirect to '/users'
    end
  end

  get "/login" do
    erb :"/users/login"
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if !user
      flash[:message] = "There is no account associated with the username: #{params[:username]}"
      redirect to '/login'
    elsif user && user.authenticate(params[:password])
      session[:id] = user.id
      redirect to '/users'
    else
      flash[:message] = "The username or password combination is incorrect"
      redirect to '/login'
    end
  end

  get "/signout" do
    session.clear
    redirect "/"
  end

  get "/users/:id/edit" do
    @user = User.find_by(id: session[:user_id])
    if @user
    erb :"/users/show.html" #add edit.erb
    end
  end
 
end