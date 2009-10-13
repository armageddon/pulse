class UserActivitiesController < ApplicationController
  def show
  
  end
  
  def destroy
    logger.info("removing activity") 
    @user_places = current_user.user_activities.all(:conditions => ["activity_id = ?", params[:activity_id]])
    @user_places.each do |ua|
      ua.delete
    end
  
    respond_to do |format|
    format.js { render :text => "deleted places" }
    format.html { render :text => "deleted places"}
    end
  end

end
