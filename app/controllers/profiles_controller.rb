class ProfilesController < ApplicationController

  before_filter :login_required

  def show
    @user = User.find_by_username(params[:id])
    @places = @user.places.paginate(:page => params[:page], :per_page => 5)
    @events = @user.events.find(:all, :include => [:place, :user])
    @user_activities = UserActivity.paginate(:select => "DISTINCT user_activities.*", :conditions => ["user_id = ?",@user.id],:page => params[:page], :per_page => 5)
    @user_place_activities = UserPlaceActivity.paginate(:all, :conditions => 'user_id = ' + @user.id.to_s, :page=> params[:page], :per_page=>10)
    # poor man's stats
    if @user != current_user
      @user.increment!(:profile_views, 1)
    end
  end

  def user_place_activities
    @user = User.find_by_username(params[:id])
    @user_place_activities = @user.user_place_activities.paginate(:all, :order=>'created_at DESC',:page=>params[:page], :per_page=>10)
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "user_place_activity_collection", :locals => { :collection => @user_place_activities } }
    end
  end
  
  
 
end
