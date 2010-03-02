class ActivitiesController < ApplicationController


  def partner
    logger.debug('partner')
    logger.debug(params[:code])
    #work out code
    @activity = Activity.find(:first,:conditions=>{:auth_code => params[:code], :admin_user_id => nil }) if params[:code] != nil
    if @activity == nil
      render :text => 'The login code you provided does not match one in our system. Please try again'
    else
      @users = @activity.users.paginate(:all,:group => :user_id, :page => params[:page], :per_page => 6)
      @user_place_activities = @activity.user_place_activities.paginate(:order=>'created_at DESC',:page=>1,:per_page=>10)
      render :template => 'activities/show', :locals => {:activity => @activity, :auth_code =>params[:code] }
    end
  end

  def show
    @activity =Activity.find(params[:id])
    @user_place_activities = @activity.user_place_activities.paginate(:order=>'created_at DESC',:page=>1,:per_page=>10)
    @user_place_activities.each do |d|
      logger.debug('UPA ID::::::::::::::::' + d.id.to_s)
    end
    @users = @activity.users.paginate(:all,:group => :user_id, :page => params[:page], :per_page => 6)
  end

  def new_test
    @user_place_activity = UserPlaceActivity.new
    respond_to do |format|
      format.html {render}
     
      format.js {render :text => 'added activity'  }
    end
  end
  
  def create
    @activity = Activity.new
    @activity.name =params[:activity_name]
    if @activity.save
      respond_to do |format|
        format.html do
          flash[:notice] = "You have added an place activity, user activity and user place"
          redirect_to account_places_path
        end
        format.js {render :text => 'added activity'  }
      end
    else
      respond_to do |format|
        format.html { render :action => :new}
        format.js { render :text => 'You have already added this activity', :status=>500 }
      end
    end
  end

  def users
    @activity=Activity.find(params[:id])
    @users = @activity.users.paginate(:all,:group => :user_id,:page=>params[:page], :per_page=>6)
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "shared_object_collections/horizontal_users_collection", :locals => { :collection => @users, :reqpath=>'/activities/users' } }
    end
  end

  def user_place_activities
    @activity=Activity.find(params[:id])
    @user_place_activities = @activity.user_place_activities.paginate(:all, :order=>'created_at DESC',:page=>params[:page], :per_page=>10)
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "user_place_activity_collection", :locals => { :collection => @user_place_activities } }
    end
  end

  def autocomplete
    s = params[:q]
    @activities = Activity.find(:all,:select=>"activities.id, activities.name, activities.activity_category_id, count(activities.id) as UPA" ,:group=>"activities.id, activities.name, activities.activity_category_id",:joins => "left join user_place_activities UPA on UPA.activity_id = activities.id", :order => "name", :conditions => ["name like ? ", "%#{params[:q]}%"])
    activity = Activity.find(:all,:select=>"activities.id, activities.name, activities.activity_category_id, 0 as UPA",:conditions=>["name = ?","#{s}"])
    res = Array.new
    if activity.length==0
      res << {:id=>0,:name=>s,:count=>'add this'}
    end
    @activities.each do |a|
      res << {:id=>a.id, :name=>a.name, :count=>a.UPA}
    end
    respond_to do |format|
      format.js { render :json => res}  #al - add json type as parameter here.
    end 
  end

  def activity_places
    activity_id = params[:activity_id]
    @places = Place.find(:all,:select=>"places.id, places.name, places.neighborhood, count(UPA.id) as UPA", :group=>"places.id, places.name,places.neighborhood",:joins=>"inner join user_place_activities UPA on UPA.place_id = places.id",:conditions=>"UPA.activity_id = " + activity_id.to_s)
    res = Array.new
    
    @places.each do |p|
      res << {:id=>p.id, :name=>p.name, :count=>p.UPA, :neighborhood=>p.neighborhood}
    end
    res <<  {:id=>0, :name=>'or Search Places >>', :neighborhood=>'', :count=>''}
    respond_to do |format|
      format.js { render :json => res}  #al - add json type as parameter here.
    end
  end
end