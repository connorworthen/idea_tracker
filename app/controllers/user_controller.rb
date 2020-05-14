 require 'rack-flash'
class UserController < ApplicationController
  
    get '/users' do
    if signed_in?
      # then find the user who's session params = to user_id
      @user = User.find(session[:user_id])
      # finally disply the todo list where user_id = to current user

        # @user = User.where(user_id: current_user)
        # binding.pry
        erb :"users/show.html"
    else
      redirect "/login"
    end
  end
  get '/users/:id' do
    if signed_in?
      @user = User.find(params[:id])
      # binding.pry
      erb :'/users/show.html'
    else
      redirect '/login'
    end
  end
  # GET: /let the user to go for the sign-in page --done
  get "/login" do
    if signed_in?
      redirect '/users'
    else
      erb :"/users/login"
    end
  end

  # GET: /let the user go for the sign-up page --done
  get "/signup" do
    if signed_in?
      redirect '/users'
    else
      erb :"/users/signup"
    end
  end

  # POST: /send the sign-in info to the server and let the user to login
  post "/login" do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/users'
    else
      redirect "/login"
    end
  end
  #POST:/send the signup infor to the serverand let the user to create account
  post "/login" do
    # if one of the entry field is empty direct to the signup page
    if params[:username].empty? || params[:email].empty? || params[:password].empty?
      redirect "/signup"
    else
      #else create a new instance of user using params
      # set session[:user_id] to newly created user id
      #finally redirect the user to the todos list page
      # binding.pry
      @user = User.create(:name => params[:username], :email => params[:email], :password => params[:password])
      # @user.save
      session[:user_id] = @user.id
      redirect "/users"
    end
  end
  get "/signout" do
    #if the user is logged in then clear the session and redirect to the /signin page
    #else redirect to the /index page
    if signed_in?
      session.destroy
      redirect "/login"
    else
      redirect "/"
    end
  end

  # GET: /users/5 show a user with specific id
  get "/users/:id/edit" do
    @user = User.find_by(id: session[:user_id])
    if @user

    # there is no relation between this line and line 37 it just bcz of redirecting due to design
    # those two values are the end up equals
    erb :"/users/show.html" #add edit.erb
    else
      redirect "/login"
    end
  end
  patch '/users/:id' do
    if signed_in?
      if params[:name].empty?
        redirect "/users/#{params[:id]}/edit"
      else
        @user = User.find_by_id(params[:id])
        if @user == current_user
          if @user.update(:name => params[:name], :email => params[:email])
            redirect to "/users/#{@user.id}"
          else
          redirect to "/users/#{@user.id}/edit"
          end
        else
          redirect to '/users'
        end
      end
    else
      redirect '/signin'
    end
  end
  # patch "/users/:id" do
  #   # raise params.inspect
  #   # fins the todo with the specific id
  #   @user = User.find(params[:id])
  #   # binding.pry
  #   @user.update(name: params[:name], email: params[:email])
  #   # binding.pry
  #     redirect "/users/#{@user.id}"
  # end
end