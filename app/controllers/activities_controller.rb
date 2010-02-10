class ActivitiesController < ApplicationController

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
    logger.debug(s)
    @activities = Activity.find(:all,:select=>"activities.id, activities.name, activities.activity_category_id, count(activities.id) as UPA" ,:group=>"activities.id, activities.name, activities.activity_category_id",:joins => "left join user_place_activities UPA on UPA.activity_id = activities.id", :order => "name", :conditions => ["name like ? ", "%#{params[:q]}%"])
    activity = Activity.find(:all,:select=>"activities.id, activities.name, activities.activity_category_id, 0 as UPA",:conditions=>["name = ?","#{s}"])
    results = ""
    if activity.length==0

      results =  "<span class='activity_dd' id = 0>"+s+"</span><span style ='font-size:10px'> (Add this)</span><br />"
    end
    # @activities = Activity.search(s)
   
    results += @activities.map {|p| "<span class='activity_dd' id = #{p.id} >#{p.name}</span><span style ='font-size:10px'> (#{p.UPA})</span><br />"}.join("")

    render :text => results
  end

  def activity_places
    activity_id = params[:activity_id]
    @places = Place.find(:all,:select=>"places.id, places.name, count(UPA.id) as UPA", :group=>"places.id, places.name",:joins=>"inner join user_place_activities UPA on UPA.place_id = places.id",:conditions=>"UPA.activity_id = " + activity_id.to_s)
    render :text => @places.map{ |p| "<span class='place_dd' id = #{p.id} >#{p.name}</span><span style ='font-size:10px'> (#{p.UPA})</span><br />"}.join("")
  end

end