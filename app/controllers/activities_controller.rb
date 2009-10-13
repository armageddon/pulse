class ActivitiesController < ApplicationController
  def show
    @activity = Activity.find(params[:id])
    @activity_users = @activity.users.paginate(:limit => 5, :page => params[:page], :per_page => 12)
    @activity_places = @activity.places.paginate(:limit => 5, :page => params[:page], :per_page => 12)
  end

  def autocomplete
    @activities = Activity.find(:all, :conditions => ["name like ? ", "#{params[:q]}%"], :limit => 10)
    results = @activities.map {|p| "#{p.name}|#{p.id}"}.join("\n")
    render :text => results
  end
end
