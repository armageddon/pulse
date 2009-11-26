class ActivitiesController < ApplicationController
  def show
    @activity = Activity.find(params[:id])

    @users = User.paginate(:select => "users.*", :joins => "inner join user_place_activities UPA on UPA.user_id = users.id  ", :conditions=>'activity_id = ' +@activity.id.to_s , :page => params[:page], :per_page => 6)
    @user_activity_comments = UserPlaceActivity.paginate(:conditions=>'activity_id = ' +@activity.id.to_s + ' and LENGTH(description) > 0', :page=>1,:per_page=>15)
    
    @activity_users = @activity.users.paginate(:limit => 5, :page => params[:page], :per_page => 12)
    @activity_places = @activity.places.paginate(:limit => 5, :page => params[:page], :per_page => 12)
  end

  def autocomplete
    @activities = Activity.find(:all, :conditions => ["name like ? ", "#{params[:q]}%"], :limit => 10)
    results = @activities.map {|p| "#{p.name}|#{p.id}"}.join("\n")
    render :text => results
  end
end
