class PlacesController < ApplicationController
  before_filter :login_required
  
  def index
    @places = Places.find(:all)
  end
  
  def show
     @place =Place.find(params[:id])
     @user_place_activities = @place.user_place_activities.paginate( :order=>'created_at DESC',:page=>1,:per_page=>10)
     @users = @place.users.paginate(:all,:group => :user_id, :page => params[:page], :per_page => 6)
  end
  
  def users
    @place=Place.find(params[:id])
    @users = @place.users.paginate(:all,:group => :user_id,:page=>params[:page], :per_page=>6)
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "shared_object_collections/horizontal_users_collection", :locals => { :collection => @users, :reqpath=>'/places/users' } }
    end
  end

  def user_place_activities
    @place=Place.find(params[:id])
    @user_place_activities = @place.user_place_activities.paginate(:all, :order=>'created_at DESC',:page=>params[:page], :per_page=>10)
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "user_place_activity_collection", :locals => { :collection => @user_place_activities } }
    end
  end
  
  def autocomplete
    @places = Place.find(:all,:order => "name", :conditions => ["name like ? ", "#{params[:q]}%"])
    results = @places.map {|p| "#{p.name}"+" <span style='font-size:9px'>#{p.neighborhood}</span>|#{p.id}"}.join("\n")
    render :text => results
  end

end