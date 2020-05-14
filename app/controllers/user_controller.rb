require 'rack-flash'
class UserController < ApplicationController
  use Rack::Flash
  
  get "/users" do
    erb :"/users/show.html"
  end

  get "/login" do
    erb :"/users/login"
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

  post "/login" do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/users' # add rack flash error msg/ error file
    end
  end

  get "/signout" do
    if signed_in?
      session.destroy
      redirect "/"
    end
  end

  get "/users/:id/edit" do
    @user = User.find_by(id: session[:user_id])
    if @user
    erb :"/users/show.html" #add edit.erb
    end
  end
 
end