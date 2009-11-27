class ActivitiesController < ApplicationController
  def show
      @activity =Activity.find(params[:id])
      @user_place_activities = @activity.user_place_activities.paginate(:page=>1,:per_page=>10)
      @users = @activity.users.paginate(:all,:group => :user_id, :page => params[:page], :per_page => 6)
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
     @user_place_activities = @activity.user_place_activities.paginate(:all,:page=>params[:page], :per_page=>10)
     respond_to do |format|
       format.html { render }
       format.js { render :partial => "user_place_activity_collection", :locals => { :collection => @user_place_activities } }
     end
   end

  def autocomplete
    @activities = Activity.find(:all, :conditions => ["name like ? ", "#{params[:q]}%"], :limit => 10)
    results = @activities.map {|p| "#{p.name}|#{p.id}"}.join("\n")
    render :text => results
  end
end
