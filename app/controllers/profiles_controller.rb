class ProfilesController < ApplicationController

  before_filter :login_required

  def show
    @user = User.find_by_username(params[:id])
    @places = @user.places.paginate(:page => params[:page], :per_page => 5)
    @events = @user.events.find(:all, :include => [:place, :user])
    @activities =  @user.activities.paginate(:select => "DISTINCT activities.*", :page => params[:page], :per_page => 5)
    # poor man's stats
    if @user != current_user
      @user.increment!(:profile_views, 1)
    end

    respond_to do |format|
      format.js do
        case params[:type]
        when "places"
          render :partial => "shared/object_collection", :locals => { :collection => @places }
        end
      end
      format.html { render }
    end
  end

end
