require 'sinatra'
require 'sinatra/authorize'

class IdeaController < ApplicationController

  get '/ideas' do
    authorize
    @ideas = Idea.all
    erb :'lists/index'
  end

  get '/ideas/new' do  
    authorize  
    erb :'lists/show'
  end

  post '/ideas/new' do     
    authorize
    u = current_user
    u.ideas.create(name: params[:name], content: params[:content])
    raise PostSiteError.new if !u.save
        # # redirect '/users/#{u.id}'
    redirect '/users'
  end

  delete '/ideas/:id' do
    idea = Idea.find_by(id: params[:id])
    authorize_user(idea)
    u = current_user
    if idea
      idea.destroy   
      redirect "/users/#{u.id}"
    end
  end

  get '/ideas/:id/edit' do
    @idea = Idea.find_by(id: params[:id])
    authorize_user(@idea)
    erb :'lists/edit'
  end

  patch '/ideas/:id' do
    u = current_user
    @idea = Idea.find_by(id: params[:id])
    authorize_user(@idea)
    @idea.update(name: params[:name], content: params[:content])
    redirect "/users/#{u.id}"
  end

end