class SessionsController < ApplicationController
  layout nil
  before_filter :load_events , :except => [:destroy]

  def load_events
    @updates = TimelineEvent.paginate( :page=>1, :conditions=>"icon_file_name is not  null",:joins=>"INNER JOIN users on users.id = timeline_events.actor_id",:per_page => 5, :order => 'created_at DESC')
  end

  def new
    if logged_in?
      return redirect_to(:controller => "users", :action => "show")
    end

  end

  def link
    logger.debug('SESSION LINK')

    user = User.authenticate(params[:login], params[:password])
    logger.debug('SESSION LINK user set')
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag

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


  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
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
