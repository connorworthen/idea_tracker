class IdeaController < ApplicationController

  get '/ideas/:id/edit' do
    redirect_login
    @idea = Idea.find(params[:id])
    current_user_owns_idea
    erb :'/ideas/edit'
  end

  patch '/ideas/:id/edit' do
    redirect_login
    @idea = Idea.find(params[:id])
    current_user_owns_idea
    @idea.update(params[:idea])
    redirect to "/lists/#{List.find((@idea.list_id)).slug}"
  end


  helpers do
    def current_user_owns_idea
      if current_user.id != List.find_by(id: @idea.list_id).user_id
        redirect to '/'
      end
    end
  end
  
end