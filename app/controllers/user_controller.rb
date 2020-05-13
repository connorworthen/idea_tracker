 require 'rack-flash'
class UserController < ApplicationController
  use Rack::Flash

   get '/users' do
    erb :'users/show.html'
   end
   
    
    post '/login' do    
        begin
            authenticate(params[:username], params[:password])
            redirect '/home'
        rescue AuthenticationError => e        
            @errors = ["Improper information entered"]
            erb :'users/login'
        end
    end

    get '/signup' do
        erb :'users/signup'
    end

end