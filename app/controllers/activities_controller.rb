class ActivitiesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:post_activity_to_facebook]
  require 'mini_fb'

  #TODO: paths connect to path provider not string

  #REST
  def update
    #todo - refactor
    activity = Activity.find(params[:activity_id])
    activity.auth_code = params[:auth_code]
    activity.fb_page_id = params[:page_id]
    activity.update_attributes(params[:activity])
    redirect_to '/activities/admin'
  end

  def show
    @activity =Activity.find(params[:id])
    @user_place_activities = @activity.user_place_activities.paginate(:order=>'created_at DESC',:page=>1,:per_page=>10)
    @users = @activity.users.paginate(:all,:group => :user_id, :page => params[:page], :per_page => 6)
  end

  def create
    @activity = Activity.new
    @activity.name =params[:activity_name]
    if @activity.save
      respond_to do |format|
        format.html do
          flash[:notice] = "You have added an place activity, user activity and user place"
          redirect_to account_places_path
        end
        format.js {render :text => 'added activity'  }
      end
    else
      respond_to do |format|
        format.html { render :action => :new}
        format.js { render :text => 'You have already added this activity', :status=>500 }
      end
    end
  end
  
  #return HTML
  def partner
    params[:id].present? ? @activity =  Activity.find(params[:id]) : @activity =  Activity.find_by_admin_user_id(current_user.id)
    render :text => 'Dear partner. An error has occured . please contact HelloPulse admin' and return if @activity == nil
    @users = @activity.users.paginate(:all,:group => :user_id, :page => params[:page], :per_page => 6)
    @user_place_activities = @activity.user_place_activities.paginate(:order=>'created_at DESC',:page=>1,:per_page=>10)
    render :template => 'activities/show', :locals => {:activity => @activity, :auth_code =>params[:code] }
    # end
  end

  def admin
    if current_user.admin
      render :template => "activities/admin", :layout => false
    else
      render :text => 'you are not authorised'
    end
  end

  def users
    @activity=Activity.find(params[:id])
    @users = @activity.users.paginate(:all,:group => :user_id,:page=>params[:page], :per_page=>6)
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "shared_object_collections/horizontal_users_collection", :locals => { :collection => @users, :reqpath=>'/activities/users' } }
    end
  end

  def user_place_activities
    @activity=Activity.find(params[:id])
    @user_place_activities = @activity.user_place_activities.paginate(:all, :order=>'created_at DESC',:page=>params[:page], :per_page=>10)
    respond_to do |format|
      format.html { render }
      format.js { render :partial => "user_place_activity_collection", :locals => { :collection => @user_place_activities } }
    end
  end
  
  #services GET JSON
  def autocomplete
    s = params[:q]
    @activities = Activity.find(:all,:select=>"activities.id, activities.name, activities.activity_category_id, count(activities.id) as UPA" ,:group=>"activities.id, activities.name, activities.activity_category_id",:joins => "left join user_place_activities UPA on UPA.activity_id = activities.id", :order => "name", :conditions => ["name like ? ", "%#{params[:q]}%"])
    activity = Activity.find(:all,:select=>"activities.id, activities.name, activities.activity_category_id, 0 as UPA",:conditions=>["name = ?","#{s}"])
    res = Array.new
    if activity.length==0
      res << {:id=>0,:name=>s,:count=>'add this'}
    end
    @activities.each do |a|
      res << {:id=>a.id, :name=>a.name, :count=>a.UPA}
    end
    respond_to do |format|
      format.js { render :json => res}  #al - add json type as parameter here.
    end
  end

  def activity_places
    activity_id = params[:activity_id]
    @places = Place.find(:all,:select=>"places.id, places.name, places.neighborhood, count(UPA.id) as UPA", :group=>"places.id, places.name,places.neighborhood",:joins=>"inner join user_place_activities UPA on UPA.place_id = places.id",:conditions=>"UPA.activity_id = " + activity_id.to_s)
    res = Array.new
    res <<  {:id=>0, :name=>'Search or Add New Places >>', :neighborhood=>'', :count=>''}
    @places.each do |p|
      res << {:id=>p.id, :name=>p.name, :count=>p.UPA, :neighborhood=>p.neighborhood}
    end
    respond_to do |format|
      format.js { render :json => res}  #al - add json type as parameter here.
    end
  end

  #services 
  def post_activity_to_facebook
    user = User.find(params[:user_id])
    activity = Activity.find(:first,:conditions=>{:admin_user_id => user.id })
    facebook_act_session = Facebooker::Session.create
    facebook_act_session.secure_with!(user.fb_session_key)
    facebook_act_session.post("facebook.stream.publish", :action_links=> '[{ "text": "Check out HelloPulse!", "href": "http://www.hellopulse.com"}]', :message => 'Some singles added ' + activity.name + ' to their HelloPulse page. ', :uid=>activity.fb_page_id)
    render :text=>'post to facebook'
  end

end

=begin
  def new_test
    cookies[:path] = "account"
    logger.debug(p MiniFB.scopes)
    @oauth_url = MiniFB.oauth_url(FB_APP_ID, # your Facebook App ID (NOT API_KEY)
      CALLBACK_URL, # redirect url
      :scope=>MiniFB.scopes.join(",")+",offline_access", :display=>"popup")
    respond_to do |format|

      format.html {render :template => '/activities/new_test.html' }
    end
  end


 def fb_pullz

    pulse_fb_session = Facebooker::Session.create
    pulse_fb_session.auth_token = "NH3XTZ"

    FbFriend.find(:all, :conditions=>'is_friend is null and id > 5552').each do |u1|
      logger.debug(p u1)
      ret = pulse_fb_session.post("facebook.friends.areFriends", :uids1=>u1.fb_user_id1, :uids2=>u1.fb_user_id2, :session_key=>"2b286349447e871211a8babd-100000807720563")
      ret.each_pair do |k,v|
        u1.is_friend=v
        u1.save
      end
    end


  end

  def fb_pullq
    #cookies[:access_token]='2227470867|2.CjcHOcPLpQ3fSY_G5dYeLA__.3600.1273694400-632510886|KWG4cKwpCJFC3ZTmEARz-bBz2gg.'
    @user = MiniFB.get(cookies[:access_token], 'me')
    @response_hash = MiniFB.get(cookies[:access_token], 'me', :type=>'friends')
    logger.debug(@user.id)

    @response_hash.data.each do |d|
      if FbUser.find_by_fb_user_id(d.id) == nil
        @user_hash =   MiniFB.get(cookies[:access_token], d.id)
        logger.debug(p @user_hash.name)


        u=FbUser.new
        u.fb_user_source_id = @user.id
        u.name =@user_hash.name
        u.fb_user_id = @user_hash.id
        u.gender=@user_hash.gender
        u.relationship = @user_hash.relationship_status
        u.location_id = @user_hash.location.id unless d.location == nil
        u.birthday=@user_hash.birthday
        u.save



        @likes_hash =  MiniFB.get(cookies[:access_token], d.id, :type=>'likes')
        @likes_hash.data.each do |e|
          logger.debug(e.name)
          l= FbUserLike.new
          l.fb_user_id = d.id
          l.category = e.category
          l.like_id =e.id
          l.like_name = e.name
          l.save
          #  end
        end


        @friend_hash =  MiniFB.get(cookies[:access_token], d.id, :type=>'events')
        @friend_hash.data.each do |e|
          f= FbUserEvent.new
          f.event_location = e.location || nil
          f.event_name = e.name || nil
          f.event_id =e.id || nil
          f.event_start = e.start_time || nil
          f.event_end =e.end_time || nil
          f.fb_user_id =d.id || nil
          f.user_name =d.name || nil
          f.save
          #  end
        end


      end
      # @response_hash = MiniFB.get(cookies[:access_token])
    end
    render :text => @response_hash
  end

  def fb_test
    cookies[:path] = "account"
    if params[:code].present?
      logger.debug('fb_test')
      p params['code']
      access_token_hash = MiniFB.oauth_access_token(FB_APP_ID, CALLBACK_URL, FB_SECRET_KEY, params[:code])
      @access_token = access_token_hash["access_token"]
      p @access_token
      cookies[:access_token] = @access_token
    end
    @user = MiniFB.get(cookies[:access_token], 'me')
    logger.debug('USERID:' +@user.id )
    self.current_user = User.find_by_fb_user_id(@user.id)
    self.current_user.access_token = @access_token
    self.current_user.save
    redirect_to "http://localhost:3000/facebook"
  end
=end