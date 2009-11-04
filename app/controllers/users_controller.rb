class UsersController < ApplicationController
include Graticule
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :login_required, :except => [:redeem, :create]


  def user_places
    @places = current_user.places;
    respond_to do |format|
       format.js { render :partial => "shared/object_collection", :locals => {:collection => @places}}
    end
  end
  #todo: where is this called
  def user_place_activities
    @activities = current_user.activities;
    respond_to do |format|
       format.js { render :partial => "shared/object_collection", :locals => {:collection => @activities}}
    end
  end
  
  def show
    logger.debug("users show")
    logger.debug(current_user.errors.full_messages)
    @places = current_user.suggested_places
    @matches = current_user.matches(params[:page], 8)
    logger.debug("matches: " + @matches.length.to_s)

  end

  def new
    logger.debug("In Create")
    @user = User.new
    @user_place_activity = UserPlaceActivity.new
  end

  def redeem
    logger.debug("Begin redeem")
       @user_place_activity = UserPlaceActivity.new
    logout_keeping_session!
    
    if params[:invite_code] == "pulse12345"
      @user = User.new
      render :action => :new, :layout => false
    else
      flash[:error] = "Sorry, we were unable to locate that invitation code."
      redirect_to '/'
    end
  end

  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    if params[:user][:postcode] != nil 
      geocoder = Graticule.service(:google).new "ABQIAAAAZ5MZiTXmjJJnKcZewvCy7RQvluhMgQuOKETgR22EPO6UaC2hYxT6h34IW54BZ084XTohEOIaUG0fog"
      location = geocoder.locate('london ' + params[:user][:postcode])
      latitude, longitude = location.coordinates
      if latitude != nil && longitude != nil
        @user.lat = latitude
        @user.long = longitude
        params[:user][:lat] = latitude
        params[:user][:long] = longitude
      end
    end
    @user.location_id = 1;
    @user.postcode = @user.postcode.upcase
    @user.register! if @user && @user.valid?
    success = @user && @user.valid?
    @user.age 
    respond_to do |format|
      if success && @user.errors.empty?
        # DEBUG
        @user.activate!
        session[:user_id] = @user.id
        format.html {
          redirect_to user_path
          flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
        }
        format.js {
          session[:user_id] = @user.id
          render :nothing => true
        }
      else
        format.html {
          render :action => 'new', :layout => false
        }
        format.js { render :json => @user.errors, :status => 500,  :layout => false }
      end
    end
  end

  def edit
     logger.debug(current_user.errors.full_messages)
    @user = current_user
  end

  def update
    
        @user_place_activity = UserPlaceActivity.new
    if params[:iframe]=="true"
       current_user.update_attributes(params[:user])
        respond_to do |format|
           format.html { render :text => current_user.icon.url(:profile) }
           format.js { render :text => current_user.icon.url + "js"}
        end
    else
       params[:user][:dob] = Date.new(params[:year].to_i(),params[:month].to_i(),params[:day].to_i())
       logger.debug(params[:user][:dob])
       logger.debug(current_user.get_age_option_from_dob(params[:user][:dob]))
       params[:user][:age] = current_user.get_age_option_from_dob(params[:user][:dob])
       geocoder = Graticule.service(:google).new "ABQIAAAAZ5MZiTXmjJJnKcZewvCy7RQvluhMgQuOKETgR22EPO6UaC2hYxT6h34IW54BZ084XTohEOIaUG0fog"
       logger.debug(params[:user][:postcode])
       if   params[:user][:postcode] != nil
         location = geocoder.locate('london ' + params[:user][:postcode])
         latitude, longitude = location.coordinates
         if latitude != nil && longitude != nil
          current_user.lat = latitude
          current_user.long = longitude
          params[:user][:lat] = latitude
          params[:user][:long] = longitude
         end
       end
       respond_to do |format|
         logger.debug(params[:user]);
       if current_user.update_attributes(params[:user])
          format.html { redirect_to account_path }
          format.js { render :nothing => true}
       else
         logger.debug(current_user.errors.full_messages);
         logger.debug("in no change")
          format.html { render :action => "edit"}
          format.js { render :nothing => true, :status => 500 }
       end
       end
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def suspend
    @user.suspend!
    redirect_to login_path
  end

  def unsuspend
    @user.unsuspend!
    redirect_to login_path
  end

  def destroy
    @user.delete!
    redirect_to login_path
  end

  def purge
    @user.destroy
    redirect_to login_path
  end

  protected

  def access_denied
    render :template => "sessions/new", :layout => false
  end

  def find_user
    @user = User.find(params[:id])
  end
end
