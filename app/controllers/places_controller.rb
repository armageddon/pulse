class PlacesController < ApplicationController
  before_filter :login_required
  
  def index
    @places = Places.find(:all)
  end

  def show
    @place=Place.find(params[:id])
    @users = User.paginate(:select => "users.*", :joins => "inner join user_place_activities UPA on UPA.user_id = users.id  ", :conditions=>'place_id = ' +@place.id.to_s , :page => params[:page], :per_page => 6)
    @user_place_comments = UserPlaceActivity.paginate(:conditions=>'place_id = ' +@place.id.to_s + ' and LENGTH(description) > 0', :page=>1,:per_page=>15)
    if logged_in?
      @place_people = @place.users.paginate(:all, :limit => 5, :page => params[:page], :per_page => 6)
    end
    @user_place_activities =  @place.user_place_activities.paginate(:select => "DISTINCT user_place_activities.*, 0 as user_count", :limit => 5, :page => params[:page], :per_page => 6)
     logger.info("responding... places show")
      respond_to do |format|
        format.html { render }
        format.js do
          case params[:type]
          when "activities"
            render :partial => "shared_object_collections/object_collection", :locals => { :collection => @user_place_activities }
          when "users"
             render :partial => "shared_object_collections/object_collection", :locals => { :collection => @place_people }
          end
        end
       
      end
  end
  
  def autocomplete
    @places = Place.find(:all,:order => "name", :conditions => ["name like ? ", "#{params[:q]}%"])
    results = @places.map {|p| "#{p.name}"+" <span style='font-size:9px'>#{p.neighborhood}</span>|#{p.id}"}.join("\n")
    render :text => results
  end

end