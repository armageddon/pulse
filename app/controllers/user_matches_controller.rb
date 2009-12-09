class UserMatchesController < ApplicationController
  before_filter :login_required
  
  def index
    @matches = current_user.matches(params[:page], 8)
    @places = current_user.suggested_places
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "shared_object_collections/users_collection",
        :locals => { :collection => @matches }
      }
    end
  end
  
  def all
    @users = User.find(:all)
  end
  

  
end
