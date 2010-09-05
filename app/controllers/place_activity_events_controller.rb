
class PlaceActivityEventsController< ApplicationController

  def show
   logger.debug('show' + params[:id])
     @place_activity=PlaceActivity.find(params[:id])
     @place = @place_activity.place
     @activity = @place_activity.activity
     @users = @place_activity.users.paginate(:all,:group => :user_id, :page => params[:page], :per_page => 6)
     @user_place_activities = @place_activity.user_place_activities.paginate( :conditions=>' description IS NOT NULL and LENGTH(description) > 0',:order=>'created_at DESC',:page=>1,:per_page=>15)
    logger.debug("@user_place_activities.length")
    logger.debug(@user_place_activities.length)
    @user_place_activity_comments = @place_activity.user_place_activities.paginate(:conditions=>' LENGTH(description) > 0', :page=>1,:per_page=>15)
     @place_activity_event = PlaceActivityEvent.find_by_place_activity_id(params[:id])
     @events=Event.find(:all, :conditions=>'place_activity_id = ' + params[:id].to_s)
  end
end
