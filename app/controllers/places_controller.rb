class PlacesController < ApplicationController

  def index
    @places = Places.find(:all)
  end

  def show
    @place = Place.find(params[:id])

    if logged_in?
      @place_people = User.paginate(:all, :conditions => {
        "favorites.place_id" => @place.id,
        "users.sex_preference" => current_user.sex
        }, :limit => 5, :include => "favorites", :page => params[:page], :per_page => 12)
    end

    @favorites = Favorite.find(:all, :conditions => {
      "favorites.place_id" => @place.id
    }, :include => :user, :limit => 5)
  end

  def autocomplete
    @places = Place.find(:all, :conditions => ["name like ? ", "#{params[:q]}%"], :limit => 10)
    results = @places.map {|p| "#{p.name}|#{p.id}"}.join("\n")
    render :text => results
  end

end