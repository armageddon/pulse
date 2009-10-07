class UserActivitiesController < ApplicationController
  before_filter :login_required

  def index
    @activities = current_user.activities
  end

  def new
    logger.debug('in new')
    logger.debug(params)
    @view = params[:view]
    logger.debug("view" + @view)
    if params[:activity_id].present?
      logger.debug(params[:activity_id])
      @activity = Activity.find(params[:activity_id])
    end
    if params[:place_id].present?
      @place = Place.find(params[:place_id])
      logger.debug("found place: name=> " + @place.name)
    end
    #todo error checking here
    #how is this adding the userid?
    @user_activity = UserActivity.new(:place_id => params[:place_id], :activity_id => params[:activity_id])
    @type = params[:type]
    logger.debug("Just before format - UA new")
    respond_to do |format|
      format.js { render :partial => "new_activity.html.erb", :locals => { :activity => @activity, :user_activity => @user_activity, :place => @place, :view => @view } }
      format.html { render }
    end
  end

  def destroy
    #depending on type - if place remove 
    @user_acts = current_user.user_activities.all(:conditions => ["place_id = ?", params[:place_id]])
    logger.debug(@user_acts.length)
    @user_acts.each do |ua|
      ua.delete
    end
    respond_to do |format|
      format.js { render :text => "deleted places" }
      format.html { render :text => "deleted places"}
    end
    
  end

  def create
    logger.debug("in user activities create")
    logger.debug(params[:place_id])
    logger.debug(params[:place_id])
    @user_activity = current_user.user_activities.build(params[:user_activity])
    @activity = Activity.find(params[:activity_id])
    @place = Place.find(params[:place_id])
    @user_activity.place = @place
    logger.debug("place id before param " + @user_activity.place.id.to_s)
    @user_activity.place = @place
    logger.debug("place id after param " + @user_activity.place.id.to_s)
    @user_activity.activity = @activity
    
    respond_to do |format|
      if @user_activity.save
        format.js {render :text => "#" +current_user.user_activities.count.to_s() +" You like to <span style='margin-top: 5px; color: rgb(153, 0, 0);'>" + @activity.name + "</span> at <span style='margin-top: 5px; color: rgb(153, 0, 0);'>" + @place.name  + "</span><br \>"   }
        format.html do
          flash[:notice] = "You have added a user activity"
          redirect_to account_places_path
        end
      else
        format.js { render :text => @user_activity.errors.full_messages, :status => 500 }
        format.html { render :action => :new}
      end
    end
  end

end
