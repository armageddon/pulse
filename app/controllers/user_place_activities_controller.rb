class UserPlaceActivitiesController < ApplicationController
  before_filter :login_required

  def index
    @activities = current_user.activities
  end

  def new
    
    @view = params[:view]
    @view ||= ""
    if params[:activity_id].present?
      @activity = Activity.find(params[:activity_id])
    end
    if params[:place_id].present?
      @place = Place.find(params[:place_id])
    end

    @user_place_activity = UserPlaceActivity.new(:place_id => params[:place_id], :activity_id => params[:activity_id], :place_activity_id => params[:place_activity_id])
    @type = params[:type]
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "new_user_place_activity.html.erb", :locals => { :activity => @activity, :user_place_activity => @user_place_activity, :place => @place, :view => @view } }
      
    end
  end

  def show
  
    @user_place_activity=UserPlaceActivity.find(params[:id])
    @place = @user_place_activity.place
    @activity = @user_place_activity.activity
    @users = User.paginate(:select => "users.*", :joins => "inner join user_place_activities UPA on UPA.user_id = users.id  ", :conditions=>'place_id = ' +@place.id.to_s + ' and activity_id = ' + @activity.id.to_s, :page => params[:page], :per_page => 6)
    @user_place_activities = UserPlaceActivity.paginate(:conditions=>'place_id = ' +@place.id.to_s + ' and activity_id = ' + @activity.id.to_s, :page=>1,:per_page=>15)
    @user_place_activity_comments = UserPlaceActivity.paginate(:conditions=>'place_id = ' +@place.id.to_s + ' and activity_id = ' + @activity.id.to_s + ' and LENGTH(description) > 0', :page=>1,:per_page=>15)
    logger.debug('SSSSSSSSSSSSSSSSSSSSSSSSSSSS' + @user_place_activity_comments.length.to_s)
  end

  def destroy

      UserPlaceActivity.find(params[:user_place_activity_id]).delete
  
    respond_to do |format|
      format.html { render :text => "deleted places"}
      format.js { render :text => "deleted places" }
      
    end
  end

  def create
    logger.debug('UPA CREATE!!!!!!!!!!!!!!!!!'+params[:activity_id])
    logger.debug('UPA CREATE!!!!!!!!!!!!!!!!!'+params[:place_id])
    if !(params[:activity_id]==ANYTHING_ACTIVITY_ID.to_s && params[:place_id]==ANYWHERE_PLACE_ID.to_s)
      @activity = Activity.find(params[:activity_id])
      @place = Place.find(params[:place_id]) 
      place_activity = PlaceActivity.find(:first,:conditions=>['place_id = ? and activity_id = ?',@place.id.to_s, @activity.id.to_s])
      if place_activity == nil
        place_activity = PlaceActivity.new(:activity_id => @activity.id, :place_id => @place.id)
        place_activity.save
      end
      @user_place_activity = current_user.user_place_activities.build(:description => params[:user_place_activity][:description], :place_id => params[:place_id], :activity_id => params[:activity_id], :day_of_week => params[:user_place_activity][:day_of_week], :time_of_day => params[:user_place_activity][:time_of_day]) 
      @user_place_activity.place_activity = place_activity
      @user_place_activity.save
      respond_to do |format|
        format.html do
          flash[:notice] = "You have added a user place activity, user activity and user place"
          redirect_to account_places_path
        end
        format.js {render :partial => 'user_place_activity', :object => @user_place_activity  }
      end
    else
      respond_to do |format|
        format.html { render :action => :new}
        format.js { render :text => 'You have already added this place or activity' }
      end
    end
  end

  def edit
    @user_place_activity = UserPlaceActivity.find(params[:id])
    @activity = @user_place_activity.activity
    @source = params[:source]
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "edit_user_place_activity.html.erb", :locals => { :user_place_activity => @user_place_activity} }
    end
  end
  def update
    source = params[:source]
    if !(params[:activity_id]==ANYTHING_ACTIVITY_ID.to_s && params[:place_id]==ANYWHERE_PLACE_ID.to_s)
      @activity = Activity.find(params[:activity_id])
      @place = Place.find(params[:place_id])
      place_activity = PlaceActivity.find(:first,:conditions=>['place_id = ? and activity_id = ?',@place.id.to_s, @activity.id.to_s])
      if place_activity == nil
        place_activity = PlaceActivity.new(:activity_id => @activity.id, :place_id => @place.id)
        place_activity.save
      end
      @user_place_activity = UserPlaceActivity.find(params[:user_place_activity_id])
      @user_place_activity.description = params[:user_place_activity][:description]
      @user_place_activity.place_id = params[:place_id]
      @user_place_activity.activity_id = params[:activity_id]
      @user_place_activity.day_of_week = params[:user_place_activity][:day_of_week]
      @user_place_activity.time_of_day = params[:user_place_activity][:time_of_day]
      @user_place_activity.place_activity = place_activity
      @user_place_activity.save
      respond_to do |format|
        format.html do
          flash[:notice] = "You have added a user place activity, user activity and user place"
          redirect_to account_places_path
        end
        format.js {render :partial => '/'+source+'/user_place_activity', :object => @user_place_activity  }
      end
    end
  end

  def list
    logger.debug('UPA LIST')
    @user_place_activities = UserPlaceActivity.paginate(:select => "user_place_activities.activity_id,user_place_activities.place_id, count(user_id) as users_count", :joins => "inner join users on users.id = user_place_activities.user_id",:group => 'user_place_activities.activity_id,user_place_activities.place_id', :conditions => 'user_id = ' + current_user.id.to_s, :page => params[:page], :per_page => 10, :order => "count(user_id) DESC")
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "shared_object_collections/favorite_place_activity_collection.html.erb", :locals => { :collection => @user_place_activities } }
    end
  end

  def happenings_list

    @user_place_activities = UserPlaceActivity.paginate(:select => "user_place_activities.activity_id,user_place_activities.place_id, count(user_id) as users_count", :order => "count(user_id) DESC", :joins => "inner join users on users.id = user_place_activities.user_id",:group => 'user_place_activities.activity_id,user_place_activities.place_id', :conditions => 'user_id = ' + current_user.id.to_s, :page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "shared_object_collections/favorite_place_activity_collection.html.erb", :locals => { :collection => @user_place_activities } }
    end
  end

end
