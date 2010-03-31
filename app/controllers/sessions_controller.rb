class SessionsController < ApplicationController
  layout nil
  before_filter :load_events , :except => [:destroy]

  def load_events
    @updates = TimelineEvent.paginate( :page=>1, :conditions=>"icon_file_name is not  null",:joins=>"INNER JOIN users on users.id = timeline_events.actor_id",:per_page => 5, :order => 'created_at DESC')
  end

  def new

    @dest =   params[:dest] if params[:dest].present?
    if logged_in?
      redirect_to '/account/edit/#notifications' and return if params[:dest].present? && params[:dest] =='unsubscribe'
      redirect_to '/add_photo' and return if params[:dest].present? && params[:dest] =='addphoto'
      return redirect_to(:controller => "users", :action => "show")
    else
      clear_fb_cookies!
      clear_facebook_session_information
    end
  end

  def link
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      logger.info('session')
      logger.info(facebook_session.user.uid)
      self.current_user.fb_user_id = facebook_session.user.uid
      logger.debug(p facebook_session)
      self.current_user.save
      account_path
      flash[:notice] = "Logged in successfully"
      redirect_to root_path
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      # render :template => "users/splash", :layout => false
      redirect_to '/'
    end

  end

  def activity_user
    @code = params[:code]||0
    logger.debug(@code)
    render :template => 'sessions/new' , :locals=>{:code => @code}
  end

  def partner_auth
    #todo - pull auth code out into seperate model
    #todo- check if logged in
    logger.debug('PARTNER AUTH - SESSIONS CONTROLLER')
    @partner_object = Activity.find(:first,:conditions=>{:auth_code => params[:code], :admin_user_id => nil }) if params[:code] != nil
    if @partner_object==nil
      @partner_object = Place.find(:first,:conditions=>{:auth_code => params[:code], :admin_user_id => nil }) if params[:code] != nil
    end
    
    if @partner_object == nil
      # render :text => 'The login code you provided does not match one in our system. Please try again'
      logger.debug('no such')
      redirect_to  :controller=>'sessions' , :action=>'partner'
    else
      @users = @partner_object.users.paginate(:all,:group => :user_id, :page => params[:page], :per_page => 6)
      @user_place_activities = @partner_object.user_place_activities.paginate(:order=>'created_at DESC',:page=>1,:per_page=>10)
      #todo user switch here
      if @partner_object.class==Place
        redirect_to '/places/partner?id='+@partner_object.id.to_s+'&code='+params[:code]
      
      else
        redirect_to '/activities/partner?id='+@partner_object.id.to_s+'&code='+params[:code]
      
      end
    end
  end

  def partner
    if logged_in? && current_user.status==3
      return redirect_to(:controller => "users", :action => "show")
    elsif logged_in? && current_user.status!=3
      return redirect_to('/account')
    else
      render :template => 'sessions/partner'
    end
  end
 
  def create
    logout_keeping_session!
    logger.debug(params[:dest]) if params[:dest].present?
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery protection if user resubmits an earlier form using back button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      account_path
      flash[:notice] = "Logged in successfully"
      redirect_to '/account/edit/#notifications' and return if params[:dest].present? && params[:dest] =='unsubscribe'
      redirect_to '/messages' and return if params[:dest].present? && params[:dest] =='message'
      redirect_to '/add_photo' and return if params[:dest].present? && params[:dest] =='addphoto'
      redirect_to root_path
    else
      note_failed_signin
      clear_fb_cookies!
      clear_facebook_session_information
      @login       = params[:login]
      @remember_me = params[:remember_me]
      # render :template => "users/splash", :layout => false
      redirect_to '/'
    end
  end

  def destroy
    logger.debug('Destroying session')
    logout_killing_session!
    #done - check what the following 2 methods do
    #they simply delete the facebook cookies and set the @facebook_session to nil
    clear_fb_cookies!
    clear_facebook_session_information
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')

  end

  protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
