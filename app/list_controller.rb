class ListController < ApplicationController

  get '/lists' do
    @lists = List.public_lists
    erb :'/lists/index'
  end

  get '/lists/:slug/edit' do
    redirect_login
    @list = List.find_by_slug(params[:slug])
    current_user_owns_list
      erb :'/lists/edit'
  end

  patch '/lists/:slug/edit' do
    @list = List.find_by_slug(params[:slug])
    @list.update(params[:list])
    redirect to "/lists/#{@list.slug}"
  end

  get '/lists/:slug' do
    redirect_login
    @list = List.find_by_slug(params[:slug])
    erb :'/lists/show'
  end

  post '/lists/:slug' do
    @idea = Idea.create(params[:idea])
    redirect to "/lists/#{params[:slug]}"
  end

  helpers do
    def current_user_owns_list
      if current_user.id != @list.user_id
        redirect to '/'
      end
    end
  end

end