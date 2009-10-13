class PlacesController < ApplicationController
  before_filter :login_required
  
  def index
    @places = Places.find(:all)
  end

  def show
    @place = Place.find(params[:id])
    if logged_in?
      @place_people = @place.users.paginate(:all, :limit => 5, :page => params[:page], :per_page => 6)
    end
    @activities =  @place.activities.paginate(:select => "DISTINCT activities.*", :limit => 5, :page => params[:page], :per_page => 6)
     logger.info("responding... places show")
      respond_to do |format|
        format.js do
          case params[:type]
          when "activities"
            render :partial => "shared/object_collection", :locals => { :collection => @activities }
          when "users"
             render :partial => "shared/object_collection", :locals => { :collection => @place_people }
          end
        end
        format.html { render }
      end
  end

  def autocomplete
    @places = Place.find(:all,:order => "name", :conditions => ["name like ? ", "#{params[:q]}%"])
    results = @places.map {|p| "#{p.name}"+" <span style='font-size:9px'>#{p.neighborhood}</span>|#{p.id}"}.join("\n")
    render :text => results
  end

end