class UserPlaceActivitiesController < ApplicationController
  before_filter :login_required

  def new_user_place_activity
    user_place_activity_id = params[:user_place_activity_id].to_i
    activity_id = params[:activity_id].to_i
    activity_name =params[:activity_name]
    place_id = params[:place_id].to_i
    neighborhood = params[:neighborhood]
    place_name = params[:place_name]
    day_of_week = params[:day_of_week]
    time_of_day = params[:time_of_day]

    if activity_id == -1
      logger.debug('act id IS -1 - creating activity')
      @activity = Activity.new
      @activity.url = BITLY_URL
      @activity.name = activity_name
      @activity.activity_category_id = 1
      @activity.save
      activity_id = @activity.id
    end
    if place_id == -1
      logger.debug('plc id IS -1 - creating place')
      @place = Place.new
      @place.url = BITLY_URL
      @place.name = place_name
      #todo: default place lat/long
      @place.latitude = 51.5065
      @place.longitude = -0.138088
      @place.neighborhood = neighborhood
      @place.save
      place_id = @place.id
    end

    place_activity = PlaceActivity.find(:first,:conditions=>['place_id = ? and activity_id = ?',place_id, activity_id])
    if place_activity == nil
      place_activity = PlaceActivity.new(:activity_id => activity_id, :place_id => place_id, :url => BITLY_URL)
      place_activity.save
    end


    if user_place_activity_id == 0
      @user_place_activity = current_user.user_place_activities.build(:description => params[:description], :place_id => place_id, :activity_id => activity_id, :day_of_week =>day_of_week, :time_of_day => time_of_day)
    else
      @user_place_activity = UserPlaceActivity.find(user_place_activity_id)
      @user_place_activity.place_id = place_id
      @user_place_activity.activity_id = activity_id
      @user_place_activity.day_of_week =  day_of_week
      @user_place_activity.time_of_day = time_of_day
      @user_place_activity.description       = params[:description]
    end
    @user_place_activity.place_activity = place_activity



    if @user_place_activity.save
      respond_to do |format|
        format.html do
          flash[:notice] = "You have added a user place activity, user activity and user place"
          redirect_to account_places_path
        end
        format.js {render :partial => 'user_place_activity', :object => @user_place_activity  }
      end
    else
      logger.debug(@user_place_activity.errors.full_messages)
      respond_to do |format|
        format.html { render :action => :new}
        format.js { render :text => 'You have already added this place or activity', :status=>500 }
      end
    end
  end

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

  def free
    @user_place_activity = UserPlaceActivity.new
    params[:add_type].present? ? @add_type = params[:add_type] : @add_type = 'both'
    @place_id = params[:place_id] if params[:place_id].present?
    @activity_id = params[:activity_id] if params[:activity_id].present?
    render :partial => "free_user_place_activity.html.erb", :locals => {:activity_id => @activity_id, :place_id => @place_id, :add_type => @add_type, :activity => @activity, :user_place_activity => @user_place_activity, :place => @place, :view => @view }
  end

  def show
    @user_place_activity=UserPlaceActivity.find(params[:id])
    @place = @user_place_activity.place
    @activity = @user_place_activity.activity
    @users = User.paginate(:select => "users.*", :joins => "inner join user_place_activities UPA on UPA.user_id = users.id  ", :conditions=>'place_id = ' +@place.id.to_s + ' and activity_id = ' + @activity.id.to_s, :page => params[:page], :per_page => 6)
    @user_place_activities = UserPlaceActivity.paginate(:conditions=>'place_id = ' +@place.id.to_s + ' and activity_id = ' + @activity.id.to_s, :page=>1,:per_page=>15)
    @user_place_activity_comments = UserPlaceActivity.paginate(:conditions=>'place_id = ' +@place.id.to_s + ' and activity_id = ' + @activity.id.to_s + ' and LENGTH(description) > 0', :page=>1,:per_page=>15)
  end

  def destroy
    UserPlaceActivity.find(params[:user_place_activity_id]).delete
    respond_to do |format|
      format.html { render :text => "deleted places"}
      format.js { render :text => "deleted places" }
    end
  end

  def create
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
      if @user_place_activity.save
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
          format.js { render :text => 'You have already added this place or activity', :status=>500 }
        end
      end
    else
      respond_to do |format|
        format.html { render :action => :new}
        format.js { render :text => 'You must select either a place or an activity (or both)', :status=>500 }
      end
    end
  end

  def edit
    @user_place_activity = UserPlaceActivity.find(params[:id])
    @activity = @user_place_activity.activity
    @source = params[:source]
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "free_user_place_activity.html.erb", :locals => { :user_place_activity => @user_place_activity, :upa_type => 'edit'} }
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
