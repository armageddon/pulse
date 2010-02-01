class SessionsController < ApplicationController
  layout nil
  
  def new
    if logged_in?
      return redirect_to(:controller => "users", :action => "show")
    else
      @updates = TimelineEvent.paginate( :page=>1, :conditions=>"icon_file_name is not  null",:joins=>"INNER JOIN users on users.id = timeline_events.actor_id",:per_page => 5, :order => 'created_at DESC')
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
    logout_killing_session!
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
