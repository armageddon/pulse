class FacebookController < ApplicationController
  require 'mini_fb'
  def index
    #@oauth_url = MiniFB.oauth_url(FB_APP_ID, CALLBACK_URL+"?path=account", # redirect url
     # :scope=>MiniFB.scopes.join(",")+",offline_access,email", :display=>"popup")
    cookies[:path] = "account"
    render :layout=>false
  end

  def callback
    MiniFB.enable_logging
    logger.info(params)
    if params[:code].present?
      access_token_hash = {}
      access_token_hash = MiniFB.oauth_access_token(FB_APP_ID, CALLBACK_URL, FB_SECRET_KEY, params[:code])
      @access_token = access_token_hash["access_token"]
      logger.info(@access_token)
      cookies[:access_token] = @access_token
    else
      logger.info('NO CODE PARAMS PRESENT')
    end
   
    cookies[:access_token] = @access_token
    logger.info('ACCESS TOKEN'  + @access_token.to_s)
    begin
      @user = MiniFB.get(@access_token, 'me')
    rescue
      logger.info('RESCUE')
      redirect_to "/" and return
    end
    user = User.find_by_fb_user_id(@user.id)
    if user != nil
      self.current_user = User.find_by_fb_user_id(@user.id)
      self.current_user.access_token = @access_token
      self.current_user.save
      redirect_to "/" and return
    else
      logger.debug('redirecting to link_page')
      redirect_to "/account/link" and return
    end
  
    redirect_to "/account"
  end

  #not used
  def fb_pull
    FbGrapher.pull(User.find_by_username("pierrearmageddon").access_token)
  end

end