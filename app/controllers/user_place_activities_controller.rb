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
    

    
    @user_place_activity = UserPlaceActivity.new(:place_id => params[:place_id], :activity_id => params[:activity_id])
    @type = params[:type]
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "new_user_place_activity.html.erb", :locals => { :activity => @activity, :user_place_activity => @user_place_activity, :place => @place, :view => @view } }
      
    end
  end

  def show
    logger.debug('show' + params[:id])
     @user_place_activity=UserPlaceActivity.find(params[:id])
     @place = @user_place_activity.place
      @activity = @user_place_activity.activity
     @users = User.paginate(:select => "users.*", :joins => "inner join user_place_activities UPA on UPA.user_id = users.id  ", :conditions=>'place_id = ' +@place.id.to_s + ' and activity_id = ' + @activity.id.to_s, :page => params[:page], :per_page => 6)
     
     
     @user_place_activities = UserPlaceActivity.paginate(:conditions=>'place_id = ' +@place.id.to_s + ' and activity_id = ' + @activity.id.to_s, :page=>1,:per_page=>15)
  end

  def destroy
    #depending on type - if place remove 
    @user_place_activities = current_user.user_place_activities.all(:conditions => ["place_id = ?", params[:place_id]])
    @user_place_activities.each do |upa|
      upa.delete
    end
    respond_to do |format|
      format.html { render :text => "deleted places"}
      format.js { render :text => "deleted places" }
      
    end
  end

  def create
    if(params[:activity_id] != "0")
      @activity = Activity.find(params[:activity_id])
    else
      @activity = Activity.find(:first)
    end
    if(params[:place_id] != "0" && params[:place_id] != "")
       @place = Place.find(params[:place_id])
     else
       @place = Place.find(:first);
    end 
    if @place != nil && @activity != nil
      @user_place_activity = current_user.user_place_activities.build(params[:user_place_activity])
      @user_place_activity.place = @place
      @user_place_activity.activity = @activity
    end
    if @place != nil
      @user_place = UserPlace.new(:user_id => current_user.id, :place_id => @place.id)
    end
    if @activity != nil
       @user_activity = UserActivity.new(:user_id => current_user.id, :activity_id => @activity.id)
    end
    error_string = ""
    
    respond_to do |format|
      upa = UserPlaceActivity.find(:all, :conditions=> 'user_id = ' + current_user.id.to_s+ ' and place_id = ' +@user_place_activity.place_id.to_s + ' and activity_id = ' + @user_place_activity.activity_id.to_s)
      logger.debug('daksjdakjsdhakjsdakjsdhaksjdhaksjdhaksjdhaksdjh' + (upa ==nil).to_s)
       logger.debug('daksjdakjsdhakjsdakjsdhaksjdhaksjdhaksjdhaksdjh' + current_user.id.to_s)
      if upa.length != 0 
        format.html { render :action => :new}
        format.js { render :text => 'You have already added this place or activity' }
      else
        if @user_place_activity!=nil && @user_place_activity.save
          logger.debug('upa')
          @user_place.save
          @user_activity.save
          format.html do
            flash[:notice] = "You have added a user place activity, user activity and user place"
            redirect_to account_places_path
          end
          #format.js { render :text => "You like to <span style='margin-top: 5px; color: rgb(153, 0, 0);'>" + @activity.name + "</span> at <span style='margin-top: 5px; color: rgb(153, 0, 0);'>" + @place.name  + "</span><br \>"   } 
          format.js {render :partial => 'shared_objects/signup_place_activity', :object => @user_place_activity  }
        elsif @user_place!=nil && @user_place.save
            format.html do
              flash[:notice] = "You have added a user place"
              redirect_to account_places_path
            end
            #format.js {render :text => "You like <span style='margin-top: 5px; color: rgb(153, 0, 0);'>" + @place.name  + "</span><br \>"   }
            format.js {render :partial => 'shared_objects/search_place_activity', :object => @user_place_activity  }
        elsif @user_activity!=nil && @user_activity.save
          logger.debug('before user_activity save')
          format.html do
            flash[:notice] = "You have added a user activity"
            redirect_to account_places_path
          end
          format.js  {render :partial => 'shared_objects/search_place_activity', :object => @user_place_activity   }
        else
          format.html { render :action => :new}
          format.js { render :text => 'You have already added this place or activity' }
        end
      end
    end
  end
end
