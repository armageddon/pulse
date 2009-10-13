class UserPlacesController < ApplicationController
  def destroy
    logger.info("removing place")
    @user_places = current_user.user_places.all(:conditions => ["place_id = ?", params[:place_id]])
    @user_places.each do |up|
      up.delete
    end
    respond_to do |format|
      format.js { render :text => "deleted places" }
      format.html { render :text => "deleted places"}
    end
  end
end
