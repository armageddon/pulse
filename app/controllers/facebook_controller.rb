class FacebookController < ApplicationController
  require 'mini_fb'
  skip_before_filter :verify_authenticity_token, :only => [:post_from_m]
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

    logger.info(params)
    MiniFB.enable_logging
    @uid = ""
    @access_token = ""
    @access_token =  decode_cookie[:access_token]
    @uid =  decode_cookie[:uid]
    @hp_user = Visitor.find_by_fb_user_id(@uid)
    begin
      @fb_user = MiniFB.get(@access_token,'me')
      @fb_pic =MiniFB.get(@access_token,'me', :type=>'picture')
      logger.debug(  @fb_user)
      @first_name = @fb_user.first_name
    rescue
      @first_name = ""
    end
    
    if @hp_user != nil && @fb_user  != nil
      @access_token =  decode_cookie[:access_token]
      @fb_user = MiniFB.get(@access_token,'me')
      @user_ids = Array.new
      @user_names = Array.new
      sql =<<-SQL
        select distinct user_id2 as userid, user_name2 as name  from relation_summary where (user_id1 = #{@fb_user.id.to_s}) and common_count > 5 union select distinct  user_id1 as userid, user_name1 as name  from relation_summary where (user_id2 = #{@fb_user.id.to_s}) and common_count > 5
      SQL
      logger.info(sql)
      r = ActiveRecord::Base.connection.execute sql

       
        r.all_hashes.each do |h|
          @user_ids << h['userid']
          @user_names << h['name']
        end
        if @user_ids.length>0
        sql1 =<<-SQL
        select distinct object_name from relation_rel where user_id1 =  #{@fb_user.id.to_s} and user_id2 =  #{@user_ids[0].to_s}
        SQL
        r = ActiveRecord::Base.connection.execute sql1
        @likes = r.all_hashes
      else
        @likes = Array.new
      end

      logger.debug(@likes)
      render :template => 'facebook/admin',:layout=>false
    elsif @hp_user != nil
      render :template => 'facebook/login',:layout=>false
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
    logger.debug(params)
    pages = Page.find(:all)
    logger.debug('POST TO NEWSFEED')
    pages.each do |p|
      logger.debug(p.page_id)
      @access_token = p.access_token
      @uid = p.page_id
      ret = MiniFB.post(@access_token, @uid, :type=>'feed',  :message=>params[:text])
    end
    
    render :text => ret
    #MiniFB.post(@access_token,  )
  end

  def post_from_m
    page = Page.find(5)
    @access_token = page.access_token
    @uid = page.page_id
    logger.debug(params)
    #ret = MiniFB.post(@access_token, @uid, :type=>'feed',  :message=>DateTime.now.to_s)
    render :text => 'ret'
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
    v = Visitor.find_by_fb_user_id(@uid)

    v = Visitor.new if v == nil
    v.fb_user_id = @uid
    v.access_token =@access_token
    v.save
    get_pages
    render :text => 'success'
  end

  def callback
path = "/"
      logger.debug(path)
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
      path = cookies[:dest] if cookies[:dest].present?
      cookies.delete :dest
      logger.debug(path)
      redirect_to path and return
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

  def facebook_summary
    @access_token =  decode_cookie[:access_token]
    @fb_user = MiniFB.get(@access_token,'me')
    sql =<<-SQL
        select distinct user_id2 as userid, user_name2 as name  from relation_summary where (user_id1 = #{@fb_user.id.to_s}) and common_count > 5 union select distinct  user_id1 as userid, user_name1 as name  from relation_summary where (user_id2 = #{@fb_user.id.to_s}) and common_count > 5
    SQL

    r = ActiveRecord::Base.connection.execute sql
    # logger.debug(r.all_hashes)



    respond_to do |format|
      format.js { render :json => r.all_hashes.to_json}
    end
  end

  def facebook_serendipity
    user_id = params[:user_id]
    friend_id = params[:friend_id]
    sql1 =<<-SQL
        select distinct object_name, object_type from relation_rel where user_id1 =  #{user_id.to_s} and user_id2 =  #{friend_id.to_s}
union
      select distinct object_name, object_type from relation_rel where user_id1 =  #{friend_id.to_s} and user_id2 =  #{user_id.to_s}
    SQL
    r = ActiveRecord::Base.connection.execute sql1
    respond_to do |format|
      format.js { render :json => r.all_hashes.to_json}
    end


  end
  def common_events

  end
  def common_events

  end
  def common_locations

  end
end