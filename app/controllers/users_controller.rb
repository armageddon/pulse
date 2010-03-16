class UsersController < ApplicationController
  include Graticule
  require 'pp'
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge, :admin_delete]
  before_filter :login_required, :except => [:redeem, :create, :link_user_accounts, :link, :quick_reg, :partner_reg, :partner_new]
  before_filter :check_user
  skip_before_filter :verify_authenticity_token, :only => [:admin_delete,:partner_new]

  def check_user
    # if current_user!=nil && current_user !=false && current_user.status==3
    #   logger.debug('partneruser - redirecting')
    #   redirect_to :controller=>'activities', :action=>'partner'
    # end
  end

  def quick_reg
    fbuser = User.find(:first,:conditions=>'fb_user_id='+facebook_session.user.id.to_s) unless facebook_session == nil 
    if(fbuser != nil)
      respond_to do |format|
        format.js { render :text => "you are already a user" }
      end
    else


      @user = User.new
      #get details from facebook
      @user.first_name  = facebook_session.user.first_name unless facebook_session == nil
      dobvars = ''
      dobvars = facebook_session.user.birthday_date.split('/') unless facebook_session == nil


      @user.dob = Date.new(dobvars[2].to_i(),dobvars[0].to_i(),dobvars[1].to_i()) if dobvars.length==3
      @user.sex = ( facebook_session.user.sex == 'female')  ? 2 :1 unless facebook_session == nil
      @user.sex_preference = (@user.sex == 1) ?  2:1 unless facebook_session == nil
      @user.description = facebook_session.user.profile_blurb unless facebook_session == nil

      logger.debug('QUICKREG')
      logger.debug( facebook_session.user.birthday_date) unless facebook_session == nil
      logger.debug( facebook_session.user.birthday) unless facebook_session == nil
      logger.debug(@user.dob)
      logger.debug(@user.sex)
      logger.debug(@user.description)

      respond_to do |format|
        format.js { render :partial => "/users/quick_reg", :locals => {:user => @user}}
      end
    end
  end

  def partner_reg
    logger.debug(params[:auth_code])
    user = User.find_by_fb_user_id(facebook_session.user.id)
    if user == nil
      respond_to do |format|
        format.js { render :partial => "/users/partner_reg", :locals=>{:object_type=>params[:object_type],:object_id=>params[:object_id], :auth_code=>params[:auth_code]}}
      end
    else
      respond_to do |format|
        format.js { render :partial => "/users/pop_up"}
      end
    end
  end

  def partner_registered
    logger.debug(params[:auth_code])
    respond_to do |format|
      format.js { render :partial => "/users/partner_registered", :locals=>{:activity_id=>params[:activity_id], :auth_code=>params[:auth_code]}}
    end
  end

  #this needs to be sorted - if no fb user redirect to link account screen
  def link_user_accounts
    if (current_user==nil) || (current_user.class!=User)|| (current_user.id==0)
      #register with fb
      #either connect existing account
      #or go to create user
      redirect_to('/account/link')
      return
      logger.debug('current user nil - link accounts')
      # User.create_from_fb_connect(facebook_session.user)
    else
      logger.debug('connect_accounts')
      #connect accounts
      #self.current_user.link_fb_connect(facebook_session.user.id) unless self.current_user.fb_user_id == facebook_session.user.id
    end
    redirect_to '/'
  end

  def link
    logger.debug('LINKLINKLINK')
    respond_to do |format|
      format.html { render :template => "/users/link_facebook"}
    end
  end

  def place_activity_list
    @user_place_activities = UserPlaceActivity.paginate(:all, :conditions => 'user_id = ' + current_user.id.to_s, :page=> params[:page], :per_page=>10)
    respond_to do |format|
      format.js { render :partial => "shared_object_collections/search_place_activity_collection", :locals => {:collection => @user_place_activities }}
    end
  end

  def favorites_list
    @favorites = User.paginate(:joins=>"inner join user_favorites on user_favorites.friend_id = users.id", :conditions => "user_favorites.user_id = " + current_user.id.to_s,:page=>params[:page],:per_page=>6)
    respond_to do |format|
      format.js { render :partial => "shared_object_collections/favorite_users_collection", :locals => {:collection => @favorites}}
    end
  end
  
  def user_places
    @places = current_user.places;
    respond_to do |format|
      format.js { render :partial => "shared_object_collections/object_collection", :locals => {:collection => @places}}
    end
  end
 
  def user_place_activities
    @activities = current_user.activities;
    respond_to do |format|
      format.js { render :partial => "shared_object_collections/object_collection", :locals => {:collection => @activities}}
    end
  end
  
  def show
    redirect_to '/activities/partner' and return if current_user.status == 3 && current_user.partner_type ==2
    redirect_to '/places/partner' and return if current_user.status == 3 && current_user.partner_type ==1
    @places = current_user.suggested_places
    @matches = current_user.matches(params[:page], 8)
    @updates = TimelineEvent.paginate(:all, :conditions => "icon_file_name is not null and users.status=1 and actor_id <> " + current_user.id.to_s,:joins=>"INNER JOIN users on users.id = timeline_events.actor_id", :page=>1, :per_page => 5, :order => 'created_at DESC')
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
    @user = User.new
    render :action => :new
  end

  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    if(simple_captcha_valid?)
      @user.sex ||= 2
      @user.age ||= 5
      @user.sex_preference ||= 1
      @user.age_preference ||= 5
      logger.debug('sdsdsd')
      logger.debug(params[:feet])
      logger.debug(params[:inches])
      cm = ((params[:feet].to_i * 12) +params[:inches].to_i ) * 2.54
      @user.height = cm
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
      @user.fb_user_id = facebook_session.user.id if facebook_session != nil
      params[:user][:dob] = Date.new(params[:year].to_i(),params[:month].to_i(),params[:day].to_i())
      @user.dob = params[:user][:dob]
      params[:user][:age] = User.get_age_option_from_dob(params[:user][:dob])
      @user.location_id = 1;
      @user.postcode = @user.postcode.upcase
      simple_captcha_valid?
      @user.register! if @user && @user.valid?
      success = @user && @user.valid?
      logger.debug('errors' )
      logger.debug(pp @user.errors)
      @user.age
      logger.debug('Success ' + success.to_s)
    else
      logger.debug('captcha failed')
      success = false
      @user.errors.add("You failed to enter a valid Captcha code - please try again");
    end
    respond_to do |format|
      logger.debug('asdasdasdasd')
      if success && @user.errors.empty?
        # DEBUG
        @user.activate!
        session[:user_id] = @user.id
        format.js {
          session[:user_id] = @user.id
          render :nothing => true
        }
        format.html {
          logger.debug('format html from create ')
          #  redirect_to :action=>'photos'
          render :text => 'user created'
          flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
        }
        
      else
        format.html {
          render :action => 'new', :layout => false
        }
        format.js { render :json => @user.errors, :status => 500,  :layout => false }
      end
    end
  end

  def partner_new
    logout_keeping_session!
    logger.debug(facebook_session.session_key)
    if(simple_captcha_valid? )
      @object_id = params[:object_id]
      @user = User.new(params[:user])
      case params[:object_type]
      when 'place'
        @object = Place.find(:first,:conditions=>{:auth_code => params[:auth_code] , :id=>@object_id, :admin_user_id => nil })
        @user .partner_type = 1
      when 'activity'
        @object = Activity.find(:first,:conditions=>{:auth_code => params[:auth_code] , :id=>@object_id, :admin_user_id => nil })
        @user .partner_type = 2
      end
      @user.fb_user_id = facebook_session.user.id
      @user.sex ||= 2
      @user.age ||= 5
      @user.sex_preference ||= 1
      @user.age_preference ||= 5
      @user.height = 100
      @user.dob = '20000101'.to_date
      @user.location_id = 1;
      @user.postcode = 'W8 6QA'
      @user.status = 3
      @user.fb_session_key = facebook_session.session_key
      @user.register! if @user && @user.valid?

      success = @user && @user.valid?
    else
      logger.debug('captcha failed')
      success = false
      @user.errors.add("You failed to enter a valid Captcha code - please try again");
    end
    respond_to do |format|
      if success && @user.errors.empty?
        logger.debug('PARTNER CREATED - MODIFYING ACTIVITY')
        @user.activate!
        @object.admin_user_id = @user.id
        @object.save
        session[:user_id] = @user.id
        facebook_session.post("facebook.stream.publish", :action_links=> '[{ "text": "Check out HelloPulse!", "href": "http://www.hellopulse.com"}]', :message => ' has partnered with HelloPulse!', :uid=>@object.fb_page_id) unless @object.fb_page_id == nil
        
        format.html {
          redirect_to :action=>'photos'
          flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
        }
        format.js {
          logger.debug('format JS after create partner user')
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

  def photos
    render :text => 'sdsd'
  end

  def update
    @user_place_activity = UserPlaceActivity.new
    if params[:iframe]=="true"
      logger.info(:params)
      current_user.crop_w = params[:crop_w]
      current_user.crop_h = params[:crop_h]
      current_user.crop_x = params[:crop_x]
      current_user.crop_y = params[:crop_y]

      current_user.update_attributes(params[:user])
      respond_to do |format|
        format.html { render :text => current_user.icon.url(:profile) }
        format.js { render :text => current_user.icon.url + "js"}
      end
    else
      if params[:year] != nil && params[:month] != nil && params[:year] != nil
        params[:user][:dob] = Date.new(params[:year].to_i(),params[:month].to_i(),params[:day].to_i())
        params[:user][:age] = User.get_age_option_from_dob(params[:user][:dob])
      end
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
      cm = ((params[:feet].to_i * 12) +params[:inches].to_i ) * 2.54
      current_user.height = cm
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

  def admin_delete
    logger.info('sdsdsd')
    if current_user.admin
      if @user != nil
        #need to delete all messages to/from this user
        @user.all_messages.each do |m|
          m.destroy
        end
        #need to delete user_place_activities from this user
        @user.user_place_activities.each do |u|
          u.destroy
        end
        #need to delete all timeline events from this user
        @user.destroy
      end
      respond_to do |format|
        format.js { render :text => "deleted"}
      end
    else
      respond_to do |format|
        format.js { render :text => "cannot delete this user"}
      end
    end
      
  end

  def destroy
    @user.delete!
    redirect_to login_path
  end

  def purge
    @user.destroy
    redirect_to login_path
  end

  def icon_crop
    respond_to do |format|
      format.js { render :partial => "users/icon_crop", :locals => {:user => current_user}}
    end
  end
  
  def admin
    logger.debug('sdsd')
    if current_user.admin
      render :template => "users/admin", :layout => false
    else
      render :text => 'you are not authorised'
    end
  end
  
  protected

  def access_denied
    @updates = TimelineEvent.paginate( :page=>1, :conditions=>"icon_file_name is not  null",:joins=>"INNER JOIN users on users.id = timeline_events.actor_id",:per_page => 5, :order => 'created_at DESC')

    render :template => "sessions/new", :layout => false
    
  end

  def find_user
    @user = User.find(params[:id])
  end
  

end
