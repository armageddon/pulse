class PlaceActivitiesController < ApplicationController
    before_filter :login_required

    def show
    logger.debug('show' + params[:id])
     @place_activity=PlaceActivity.find(params[:id])
     @place = @place_activity.place
     @activity = @place_activity.activity
     @users = @place_activity.users.paginate(:all,:group => :user_id, :page => params[:page], :per_page => 6)
     @user_place_activities = @place_activity.user_place_activities.paginate(:page=>1,:per_page=>15)
     @user_place_activity_comments = @place_activity.user_place_activities.paginate(:conditions=>' LENGTH(description) > 0', :page=>1,:per_page=>15)
  end
  
  def users
    @place_activity=PlaceActivity.find(params[:id])
    @users = @place_activity.users.paginate(:all,:group => :user_id,:page=>params[:page], :per_page=>6)
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "shared_object_collections/horizontal_users_collection", :locals => { :collection => @users, :reqpath=>'/place_activities/users' } }
    end
  end

  def user_place_activities
    @place_activity=PlaceActivity.find(params[:id])
    @user_place_activities = @place_activity.user_place_activities.paginate(:all,:page=>params[:page], :per_page=>10)
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "user_place_activity_collection", :locals => { :collection => @user_place_activities } }
    end
  end
end
