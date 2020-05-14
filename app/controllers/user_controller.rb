 require 'rack-flash'
class UserController < ApplicationController
  use Rack::Flash

   get '/users' do
    erb :'users/show.html'
   end

   get "/login" do
      erb :"/users/login"
   end

  # GET: /let the user go for the sign-up page --done
  get '/signup' do
    erb :'users/signup'
  end

  # POST: /send the sign-in info to the server and let the user to login
  post "/login" do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/users'
    # else
    #   redirect "/signup"
    end
  end
  #POST:/send the signup infor to the serverand let the user to create account
  post "/signup" do
    # if one of the entry field is empty direct to the signup page
    if params[:name].empty? || params[:email].empty? || params[:password].empty?
      redirect "/signup"
    else
      #else create a new instance of user using params
      # set session[:user_id] to newly created user id
      #finally redirect the user to the todos list page
      # binding.pry
      @user = User.create(:name => params[:name], :email => params[:email], :password => params[:password])
      # @user.save
      session[:user_id] = @user.id
      redirect "/todos"
    end
  end

end