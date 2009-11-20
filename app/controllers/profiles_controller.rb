class ProfilesController < ApplicationController

  before_filter :login_required

  def show
    @user = User.find_by_username(params[:id])
    @places = @user.places.paginate(:page => params[:page], :per_page => 5)
    @events = @user.events.find(:all, :include => [:place, :user])
    @user_activities = UserActivity.paginate(:select => "DISTINCT user_activities.*", :conditions => ["user_id = ?",@user.id],:page => params[:page], :per_page => 5)
    #@activities =  @user.activities.paginate(:select => "DISTINCT activities.*", :page => params[:page], :per_page => 5)
    # poor man's stats
    if @user != current_user
      @user.increment!(:profile_views, 1)
    end
    logger.info("responding... profiles show")
    respond_to do |format|
      format.html { render }
      format.js do
        case params[:type]
        when "places"
          render :partial => "shared_object_collections/object_collection", :locals => { :collection => @places }
        when "user_place_activities"
           render :partial => "shared_object_collections/object_collection", :locals => { :collection => @user_activities }
        end
      end
      
    end
  end

 
end
