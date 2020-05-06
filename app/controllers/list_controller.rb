class SessionController < ApplicationController

  get '/login' do
    erb :'sessions/login'
  end

  post '/login' do
    begin
      authenticate(params[:username], params[:password])
      redirect '/home'
    rescue AuthenticationError => exception
      @errors = ["Invalid username or password. Please try again."]
      erb :'sessions/login'
    end
  end

  get '/signup' do
    erb :'sessions/signup'
  end
end