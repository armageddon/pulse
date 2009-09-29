class PlacesController < ApplicationController
  before_filter :login_required
  
  def index
    @places = Places.find(:all)
  end

  def show
    @place = Place.find(params[:id])

    if logged_in?
      @place_people = @place.users.paginate(:all, :limit => 5, :page => params[:page], :per_page => 12)
    end
    @activities =  @place.activities.paginate(:select => "DISTINCT activities.*", :limit => 5, :page => params[:page], :per_page => 12)
    
  end

  def autocomplete
    @places = Place.find(:all, :conditions => ["name like ? ", "#{params[:q]}%"], :limit => 10)
    results = @places.map {|p| "#{p.name}|#{p.id}"}.join("\n")
    render :text => results
  end

end