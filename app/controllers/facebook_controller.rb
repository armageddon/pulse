class FacebookController < ApplicationController
  require 'mini_fb'

  def get_pages
    begin
      @response_hash = MiniFB.get(@access_token, @uid, :type=>'accounts')
      @response_hash.data.each do |p|
        page = Page.new
        page.access_token = p.access_token
        page.administrator_id = @uid
        page.name = p.name
        page.page_id = p.id
        page.save
      end
      logger.debug(@page_access_token)
      logger.debug(@response_hash)
    rescue
      logger.error("Error")
    end
  end



  def decode_cookie
split_char = '='
    if params[:session].present?
      logger.debug("session" +params[:session])
      access_token = ""
      sess = params[:session].chomp('}').reverse.chomp('{').reverse
      sess=sess.sub!('"','')
      valar = sess.split(',')
      split_char = ':'
    else
      logger.debug("cookie")
      val = ""
      uid = 0
      access_token = ""
      values = {}
      cookies.each do |c, v|
        logger.debug(c)
        if c=="fbs_"+FB_APP_ID.to_s
          logger.debug(v)
          val = v
        end
      end
      valar = val.split("&")
    end
    valar.each do |f|
      item = f.split(split_char)
      if item.length==2
        uid = item[1].reverse.chomp('"').reverse.chomp('"') if item[0].reverse.chomp('"').reverse.chomp('"') == "uid"
        access_token = item[1].reverse.chomp('"').reverse.chomp('"') if item[0].reverse.chomp('"').reverse.chomp('"') == "access_token"
      end
    end
    values = {:uid=>uid,:access_token=>access_token}
    values
  end

  def index
    #@oauth_url = MiniFB.oauth_url(FB_APP_ID, CALLBACK_URL+"?path=account", # redirect url
    # :scope=>MiniFB.scopes.join(",")+",offline_access,email", :display=>"popup")
    logger.info(params)
    MiniFB.enable_logging
    @uid = ""
    @access_token = ""
    @access_token =  decode_cookie[:access_token]
    @uid =  decode_cookie[:uid]
    @hp_user = Visitor.find_by_fb_user_id(@uid)
    begin
    @fb_user = MiniFB.get(@access_token,'me')
    @first_name = @fb_user.first_name
    rescue
@first_name = ""
    end
    
    if @hp_user != nil && @hp_user.admin ==1     
      render :template => 'facebook/admin',:layout=>false
    elsif @hp_user != nil
      render :template => 'facebook/partner',:layout=>false
    else
      render :template => 'facebook/login',:layout=>false
    end
    cookies[:path] = "account"
  end

  def facebook_stats
    MiniFB.enable_logging
    pages = Page.find(:all)
    visitor = Visitor.find(:last)
    logger.info(pages.length)
    @pages = []
    pages.find(:all).each do |p|

     # @response_hash = MiniFB.get(p.access_token, p.page_id, {:session_key=>})
      #logger.debug(MiniFB.rest(p.access_token,'pages.getinfo',{:key=>FB_APP_KEY,:page_id=>p.page_id,:fields=>'name'}))
        # @pages << MiniFB.get(p.access_token, p.fb_user_id, :type=>'friends')
        #@pages << MiniFB.get(p.access_token.to_s, p.page_id)
        @access_token = p.access_token
        @page_id = p.page_id
         @pages << MiniFB.get(@access_token, @page_id).fan_count
   #      @pages << MiniFB.get(Page.find(2).access_token, Page.find(2).page_id).fan_count
      #   @pages << MiniFB.get(Page.find(:last).access_token, Page.find(:last).page_id).fan_count
      #q="select name,  from page where page_id  =" + p.page_id.to_s

   # @pages << MiniFB.fql(visitor.access_token, q)
    end
    
render :text => @pages
  end

  def facebook_tab
    render :template => 'facebook/show', :layout=>false
  end

  def post_to_newsfeed
    pages = Page.find(:all)
    logger.debug('POST TO NEWSFEED')
    pages.each do |p|
      @access_token = p.access_token
    @uid = p.page_id
    ret = MiniFB.post(@access_token, @uid, :type=>'feed',  :message=>"message")
    end
    
    render :text => ret
    #MiniFB.post(@access_token,  )
  end



  def new_visitor
    @uid = ""
    @access_token = ""
    val = ""
    cookies.each do |c, v|
      if c=="fbs_"+FB_APP_ID.to_s
        logger.debug(v)
        val = v
      end
    end
    valar = val.split("&")
    logger.debug(valar.length)
    valar.each do |f|
      item = f.split("=")
      if item.length==2
        logger.debug( item[0] + '      ' +  item[1])
        @uid = item[1].chomp('"') if item[0] == "uid"
        @access_token = item[1].chomp('"') if item[0].reverse.chomp('"').reverse == "access_token"
      end
    end
    v = Visitor.new
    v.fb_user_id = @uid
    v.access_token =@access_token
    v.save
    get_pages
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