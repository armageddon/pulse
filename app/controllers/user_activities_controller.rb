class UserActivitiesController < ApplicationController
  before_filter :login_required

  def index
    @activities = current_user.activities
  end

  def new
    logger.debug('in new')
    logger.debug(params)
    if params[:activity_id].present?
      @actvitiy = Activity.find(params[:activity_id])
    else
      @activity = Activity.new
    end
    
    if params[:place_id].present?
      @place = Place.find(params[:place_id])
    end
    @user_activity = UserActivity.new(:place_id => params[:place_id], :activity_id => params[:activity_id])
    logger.debug("Just before format - UA new")
    respond_to do |format|
      format.js { render :partial => "new_activity.html.erb", :locals => { :activity => @activity, :user_activity => @user_activity, :place => @place } }
      format.html { render }
    end
  end

  def destroy
    activity = current_user.activities.find(params[:id])
    current_user.activities.delete(activity)
    redirect_to account_activities_path
  end

  def create
    logger.debug("in user activities create")
    @user_activity = current_user.user_activities.build(params[:user_activity])
    @activity = Activity.find(params[:user_activity][:activity_id])
    @place = Place.find(params[:place_id])
    @user_activity.place = @place
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
        format.html { render :action => :new }
      end
    end
  end

end
