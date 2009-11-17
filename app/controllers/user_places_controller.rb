class UserPlacesController < ApplicationController
  def destroy
    logger.info("removing place")
    @user_places = current_user.user_places.all(:conditions => ["place_id = ?", params[:place_id]])
    @user_places.each do |up|
      up.delete
    end
    respond_to do |format|
      format.html { render :text => "deleted places"}
      format.js { render :text => "deleted places" }
      
    end
  end
  
 def create
   logger.debug('in up create')
 end
 
 def new
   logger.debug('in up new')
   
 end
end
