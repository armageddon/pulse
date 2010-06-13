class FacebookController < ApplicationController
  require 'mini_fb'
  def index
      @oauth_url = MiniFB.oauth_url(FB_APP_ID, CALLBACK_URL+"?path=account", # redirect url
      :scope=>MiniFB.scopes.join(",")+",offline_access,email", :display=>"popup")
    cookies[:path] = "account"
    render  :layout=>false
  end

  def callback
    logger.debug('XXXXXXXXXXXXXXXXXXXXXXXXX')
    #need to decide where to redirect to
    #if user  does not exist then go to link with dest so can redirect to original page.
    #if user exists then go to page button was pressedon
    cookies[:access_token] = ""
    if params[:code].present?
      logger.debug('fb_test')
      p params['code']
      access_token_hash = MiniFB.oauth_access_token(FB_APP_ID, CALLBACK_URL, FB_SECRET_KEY, params[:code])
      logger.debug('XXXXXXXX' + access_token_hash["access_token"])
      @access_token = access_token_hash["access_token"]
      logger.debug(@access_token)
      cookies[:access_token] = @access_token
    end
    @user = MiniFB.get(cookies[:access_token], 'me')
    logger.debug('USERID:' +@user.id )
    user = User.find_by_fb_user_id(@user.id)
    if user != nil
    self.current_user = User.find_by_fb_user_id(@user.id)
    self.current_user.access_token = @access_token
    self.current_user.save
    redirect_to "/"+cookies[:path]
    else
      logger.debug('redirecting to link_page')
       redirect_to  "/account/link" and return
    end
  end


end