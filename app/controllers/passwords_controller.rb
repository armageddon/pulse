class PasswordsController < ApplicationController
  before_filter :login_from_cookie
  before_filter :login_required, :except => [:create, :new, :message]
 
  # Don't write passwords as plain text to the log files
  filter_parameter_logging :old_password, :password, :password_confirmation
 
  # GETs should be safe
  verify :method => :post, :only => [:create], :redirect_to => { :controller => :site }
  verify :method => :put, :only => [:update], :redirect_to => { :controller => :site }
 
  # POST /passwords
  # Forgot password
  def create
    respond_to do |format|
      logger.debug('before')
      user = User.find_by_email_and_login(params[:email], params[:login])
      logger.debug('after')
      if user
        logger.debug('user')
        @new_password = random_password
        user.password = user.password_confirmation = @new_password
        user.save_without_validation
        UserMailer.deliver_new_password(user, @new_password)
 
        format.html {
          
          flash[:notice] = "We sent a new password to #{params[:email]}"
          redirect_to '/passwords/message'
        }
      else
         logger.debug('no user')
        flash[:notice] =  "We can't find that account.  Please try again."
        format.html { render :action => "new" }
      end
    end
  end
 
  # GET /users/1/password/edit
  # Changing password
  def edit
    @user = current_user
  end
 
  # PUT /users/1/password
  # Changing password
  def update
    @user = current_user
 
    old_password = params[:old_password]
 
    @user.attributes = params[:user]
 
    respond_to do |format|
      if @user.authenticated?(old_password) && @user.save
        format.html { redirect_to user_path(@user) }
      else
        format.html { render :action => 'edit' }
      end
    end
  end
 
  protected
 
  def random_password( len = 20 )
    chars = (("a".."z").to_a + ("1".."9").to_a )- %w(i o 0 1 l 0)
    newpass = Array.new(len, '').collect{chars[rand(chars.size)]}.join
  end
 
end