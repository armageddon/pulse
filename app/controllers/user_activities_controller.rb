class UserActivitiesController < ApplicationController
  before_filter :login_required

  def index
    @activities = current_user.activities
  end

  def new
    if params[:activity_id].present?
      @actvitiy = Activity.find(params[:activity_id])
    else
      @activity = Activity.new
    end

    respond_to do |format|
      format.js { render :partial => "new_activity", :locals => { :activity => @activity } }
      format.html { render }
    end
  end

  def destroy
    activity = current_user.activities.find(params[:id])
    current_user.activities.delete(activity)
    redirect_to account_activities_path
  end

  def create
    @activity = Activity.find(params[:activity][:id])
    @user_activity = UserActivity.create(:user => current_user, :activity => @activity, :description => params[:activity][:description])
    render :nothing => true
  end

end
