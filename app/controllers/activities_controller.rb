class ActivitiesController < ApplicationController
  include CrmData
  skip_before_filter :verify_authenticity_token, :only => [:post_activity_to_facebook]
  require 'mini_fb'
  
  def post_activity_to_facebook
    user = User.find(params[:user_id])
    activity = Activity.find(:first,:conditions=>{:admin_user_id => user.id })
    facebook_act_session = Facebooker::Session.create
    facebook_act_session.secure_with!(user.fb_session_key)
    facebook_act_session.post("facebook.stream.publish", :action_links=> '[{ "text": "Check out HelloPulse!", "href": "http://www.hellopulse.com"}]', :message => 'Some singles added ' + activity.name + ' to their HelloPulse page. ', :uid=>activity.fb_page_id)
    render :text=>'post to facebook'
  end

  def partner
    #@activity = Activity.find(:first,:conditions=>{:auth_code => params[:code], :admin_user_id => nil }) if params[:code] != nil
    #   if @activity == nil && current_user!= false &&current_user.status==3
    #       @activity = Activity.find(:first,:conditions=>{ :admin_user_id => current_user.id })
    #   end
    # if @activity == nil
    # render :text => 'The login code you provided does not match one in our system. Please try again'
    #  logger.debug('no such')
    #  redirect_to  :controller=>'sessions' , :action=>'partner'
    #else
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

  def update
    activity = Activity.find(params[:activity_id])
    activity.auth_code = params[:auth_code]
    activity.fb_page_id = params[:page_id]
    activity.update_attributes(params[:activity])
    redirect_to '/activities/admin'
  end

  def show
    # login_from_fb
    @activity =Activity.find(params[:id])
    @user_place_activities = @activity.user_place_activities.paginate(:order=>'created_at DESC',:page=>1,:per_page=>10)
    @users = @activity.users.paginate(:all,:group => :user_id, :page => params[:page], :per_page => 6)
  end

  def mail_test
 
    @host =  "http://www.hellopulse.com"
    @user = current_user
    
    case params[:type]
    when 'activities'
      @meet_her_url = "http://aeser.co.uk/g/button-meet-her.jpg"
      @meet_him_url = "http://aeser.co.uk/g/button-meet-him.jpg"
      @host =  "http://www.hellopulse.com"
      @user = User.find(32)
      @subject = "What’s shaking on HelloPulse?"
      @gender = @user.sex_preference == 1 ? 'men' : 'women'
      @crm_activitites = CrmData.crm_activitites(current_user,3)
      @users = Array.new
      @happenings = Array.new
      @crm_activitites.each do |u|
        @users << u
        @happenings << u.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
      end

      
      render :template => 'user_mailer/activity_reminder' , :layout => false
   
    when 'happenings'
      @subject = "Here are the singles pulsing in London"
      @user = current_user
      @heading = "Great to have you on board. Check out your weekly matches!"
      @meet_her_url = "http://aeser.co.uk/g/button-meet-her.jpg"
      @meet_him_url = "http://aeser.co.uk/g/button-meet-him.jpg"
      #todo: allow for men and women here#
      #todo: ensure happening is the latest one
      @gender = @user.sex_preference == 1 ? 'men' : 'women'
      @users = Array.new
      @happenings = Array.new
      CrmData.crm_matches(current_user,5).each do |u|
        @users << u
        @happenings << u.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
      end
      render :template => 'user_mailer/daily_matches' , :layout => false

    when 'welcome'
      render :template => 'user_mailer/signup_notification' , :layout => false

    when 'notifications'
      @users = Array.new
      @happenings = Array.new
      @user = current_user
      @crm_activitites = CrmData.crm_activitites(@user,3)
      @meet_her_url = "http://aeser.co.uk/g/button-meet-her.jpg"
      @meet_him_url = "http://aeser.co.uk/g/button-meet-him.jpg"
      @friend=User.find(32)
      @crm_activitites.each do |u|
        @users << u
        @happenings << u.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
      end

      @subject = "What’s shaking on HelloPulse?"
      @content_type =  "text/html"
      render :template => 'user_mailer/notification' , :layout => false

    when 'photos'
      @subject = "No photo, No action"
      @user = current_user
      #todo: allow for men and women here
      @gender = @user.sex_preference == 1 ? 'men' : 'women'
      @crm_photos = CrmData.crm_photos(current_user,4)
      @user1 = @crm_photos[0]
      @user2  =  @crm_photos[1]
      @user3 = @crm_photos[2]
      @user4 = @crm_photos[3]
      render :template => 'user_mailer/photo_reminder' , :layout => false
    else
      
    end
    
  end


  def fb_pull

    q = "SELECT eid,uid, rsvp_status from event_member where uid = 688967986"

    @user = MiniFB.get(cookies[:access_token], 'me')

    sql =<<-SQL
       DELETE FROM fb_user_events where fb_user_id in (select fb_user_id from fb_users where fb_user_source_id = #{@user.id})
    SQL
    r = ActiveRecord::Base.connection.execute sql
    sql =<<-SQL
         DELETE FROM fb_user_likes where fb_user_id in (select fb_user_id from fb_users where fb_user_source_id = #{@user.id})
    SQL
    r = ActiveRecord::Base.connection.execute sql
    sql =<<-SQL
       DELETE FROM fb_users where fb_user_source_id = #{@user.id};
    SQL
    r = ActiveRecord::Base.connection.execute sql

    @response_hash = MiniFB.get(cookies[:access_token], @user.id, :type=>'friends')

    logger.debug(@response_hash.data.length)
    s1 = ""
    s2 = ""
    s3 = ""
    s4 = ""
    s5 = ""
    @response_hash.data.each do |d|
      s1 +=d.id.to_s + ',' if d.id.to_i%5 == 0
      s2 +=d.id.to_s + ',' if d.id.to_i%5== 1
      s3 +=d.id.to_s + ',' if d.id.to_i%5 == 2
      s4 +=d.id.to_s + ',' if d.id.to_i%5 == 3
      s5 +=d.id.to_s + ',' if d.id.to_i%5 == 4
    end
    logger.debug(s1.chomp(','))

    q="select uid, first_name, name, current_location, meeting_for, meeting_sex, religion, relationship_status, birthday_date, birthday , sex , hometown_location from user where uid in ("+ s1.chomp(',') + ") "
    @users1 = MiniFB.fql(cookies[:access_token], q)
    q="select uid, first_name, name, current_location, meeting_for, meeting_sex, religion, relationship_status, birthday_date, birthday , sex , hometown_location from user where uid in ("+ s2.chomp(',') + ") "
    @users2= MiniFB.fql(cookies[:access_token], q)
    q="select uid, first_name, name, current_location, meeting_for, meeting_sex, religion, relationship_status, birthday_date, birthday , sex , hometown_location from user where uid in ("+ s3.chomp(',') + ") "
    @users3 = MiniFB.fql(cookies[:access_token], q)
    q="select uid, first_name, name, current_location, meeting_for, meeting_sex, religion, relationship_status, birthday_date, birthday , sex , hometown_location from user where uid in ("+ s4.chomp(',') + ") "
    @users4 = MiniFB.fql(cookies[:access_token], q)
    q="select uid, first_name, name, current_location, meeting_for, meeting_sex, religion, relationship_status, birthday_date, birthday , sex , hometown_location from user where uid in ("+ s5.chomp(',') + ") "
    @users5 = MiniFB.fql(cookies[:access_token], q)
    @users = @users1|@users2|@users3|@users4|@users5

    (0..@users.length-1).each do |e|

      usr = @users[e]
      logger.debug(usr)
      htl_id = 0
      cl_id = 0
      fb_user_id = usr.uid
      name = usr.name.gsub(/\\/, '\&\&').gsub(/'/, "''")
      gender = usr.sex
      relationship = usr.relationship_status.gsub(/\\/, '\&\&').gsub(/'/, "''") if usr.relationship_status!= nil
      birthday = usr.birthday_date
      first_name = usr.first_name.gsub(/\\/, '\&\&').gsub(/'/, "''") if usr.first_name nil
      religion = usr.religion.gsub(/\\/, '\&\&').gsub(/'/, "''") if usr.religion != nil
      meeting_for = p usr.meeting_for
      meeting_sex = usr.meeting_sex if usr.meeting_sex != nil
      fb_user_source_id = @user.id
      cl_country = usr[:current_location][:country].gsub(/\\/, '\&\&').gsub(/'/, "''") if usr[:current_location].present? &&usr[:current_location][:country].present?
      cl_city = usr[:current_location][:city].gsub(/\\/, '\&\&').gsub(/'/, "''") if usr[:current_location].present? &&usr[:current_location][:city].present?
      cl_state  = usr[:current_location][:state].gsub(/\\/, '\&\&').gsub(/'/, "''") if usr[:current_location].present? &&usr[:current_location][:state].present?
      cl_id = usr[:current_location][:id] if usr[:current_location].present? &&usr[:current_location][:id].present?
      cl_zip = usr[:current_location][:zip].gsub(/\\/, '\&\&').gsub(/'/, "''") if usr[:current_location].present? &&usr[:current_location][:zip].present?
      htl_country   = usr[:hometown_location][:country].gsub(/\\/, '\&\&').gsub(/'/, "''") if usr[:hometown_location].present? &&usr[:hometown_location][:country].present?
      htl_city= usr[:hometown_location][:city].gsub(/\\/, '\&\&').gsub(/'/, "''") if usr[:hometown_location].present? &&usr[:hometown_location][:city].present?
      htl_state = usr[:hometown_location][:state].gsub(/\\/, '\&\&').gsub(/'/, "''") if usr[:hometown_location].present? &&usr[:hometown_location][:state].present?

      htl_id= usr[:hometown_location][:id] if usr[:hometown_location].present? &&usr[:hometown_location][:id].present?
      htl_zip= usr[:hometown_location][:zip].gsub(/\\/, '\&\&').gsub(/'/, "''") if usr[:hometown_location].present? &&usr[:hometown_location][:zip].present?


      sql =<<-SQL
       insert into fb_users
       (fb_user_id,
        name,
        gender,
        relationship,
        birthday,
        first_name,
        religion,
        meeting_for,
        meeting_sex,
        cl_country,
        cl_city,
        cl_state,
        cl_id,
        cl_zip,
        htl_country,
        htl_city,
        htl_state,
        htl_id,
        htl_zip ,
fb_user_source_id)
        values (
        #{fb_user_id},
        '#{name}',
        '#{gender}',
        '#{relationship}',
        '#{birthday}',
        '#{first_name}',
        '#{religion}',
        '#{meeting_for}',
        '#{meeting_sex}',
        '#{cl_country}',
        '#{cl_city}',
        '#{cl_state}',
        #{cl_id},
        '#{cl_zip}',
        '#{htl_country}',
        '#{htl_city}',
        '#{htl_state}',
        #{htl_id},
        '#{htl_zip}' ,
        #{fb_user_source_id})

      SQL
      r = ActiveRecord::Base.connection.execute sql
    end

    #EVENTS
    q="select uid, eid, rsvp_status  from event_member where uid in ("+ s1.chomp(',') + ") and rsvp_status in  ('attending','unsure')"
    @events1 = MiniFB.fql(cookies[:access_token], q)
    q="select uid, eid, rsvp_status from event_member where uid in ("+ s2.chomp(',') + ") and rsvp_status in  ('attending','unsure')"
    @events2 = MiniFB.fql(cookies[:access_token], q)
    q="select uid, eid, rsvp_status from event_member where uid in ("+ s3.chomp(',') + ") and rsvp_status in  ('attending','unsure')"
    @events3 = MiniFB.fql(cookies[:access_token], q)
    q="select uid, eid, rsvp_status from event_member where uid in ("+ s4.chomp(',') + ") and rsvp_status in  ('attending','unsure')"
    @events4 = MiniFB.fql(cookies[:access_token], q)
    q="select uid, eid, rsvp_status from event_member where uid in ("+ s5.chomp(',') + ") and rsvp_status in  ('attending','unsure')"
    @events5 = MiniFB.fql(cookies[:access_token], q)
    @events = @events1|@events2|@events3|@events4|@events5
    logger.debug(@events)

    (0..@events.length-1).each do |e|
      sql =<<-SQL
       insert into fb_user_events (fb_user_id, event_id, rsvp_status) values (#{@events[e].uid},#{@events[e].eid},'#{@events[e].rsvp_status}')
      SQL
      r = ActiveRecord::Base.connection.execute sql
    end
    @event_mems = FbUserEvent.find(:all, :select=> "distinct event_id", :conditions=> "event_name is null")
    listring = ""
    i=0

    @event_mems.each do |li|
      i+=1
      listring += li.event_id.to_s + ','
      if i% 500 == 0 || i == @event_mems.length
        logger.debug(listring)
        #do the query on likes and then update likes table
        q = "select eid,name,location,start_time, end_time,event_type, event_subtype, venue from event where eid in ("+ listring.chomp(',') + ") "
        #logger.debug(q)
        @lis= MiniFB.fql(cookies[:access_token], q)
        #logger.debug(@lis)
        #update vent here

        @lis.each do |evnt|
          logger.debug(evnt.venue)
          latitude = 0
          longitude = 0
          name = evnt.name.gsub(/\\/, '\&\&').gsub(/'/, "''")
          start_time = evnt.start_time
          end_time  = evnt.end_time
          city = evnt.venue[:city].gsub(/\\/, '\&\&').gsub(/'/, "''") if evnt[:venue].present? && evnt[:venue][:city].present?
          country = evnt.venue[:country].gsub(/\\/, '\&\&').gsub(/'/, "''") if evnt[:venue].present? && evnt[:venue][:country].present?
          latitude = evnt.venue[:latitude] if evnt[:venue].present? && evnt[:venue][:latitude].present?
          longitude = evnt.venue[:longitude] if evnt[:venue].present? && evnt[:venue][:longitude].present?
          state = evnt.venue[:state].gsub(/\\/, '\&\&').gsub(/'/, "''") if evnt[:venue].present? && evnt[:venue][:state].present?
          street = evnt.venue[:street].gsub(/\\/, '\&\&').gsub(/'/, "''") if evnt[:venue].present? && evnt[:venue][:street].present?
          location = evnt.location.gsub(/\\/, '\&\&').gsub(/'/, "''")

          sql =<<-SQL
                update fb_user_events set
                event_name = '#{name}' ,
                start_time = '#{start_time}' ,
                end_time = '#{end_time}' ,
                city = '#{city}' ,
                country = '#{country}' ,
                latitude = #{latitude} ,
                longitude = #{longitude},
                state = '#{state}' ,
                street = '#{street}' ,
                event_location = '#{location}'
                where event_id = #{evnt.eid}
          SQL
          r = ActiveRecord::Base.connection.execute sql
        end
        listring = ""
      end
    end
    q="select uid, page_id, type from page_fan where uid in ("+ s1.chomp(',') + ") "
    @user1 = MiniFB.fql(cookies[:access_token], q)
    q="select uid, page_id, type from page_fan where uid in ("+ s2.chomp(',') + ") "
    @user2 = MiniFB.fql(cookies[:access_token], q)
    q="select uid, page_id, type from page_fan where uid in ("+ s3.chomp(',') + ") "
    @user3 = MiniFB.fql(cookies[:access_token], q)
    q="select uid, page_id, type from page_fan where uid in ("+ s4.chomp(',') + ") "
    @user4 = MiniFB.fql(cookies[:access_token], q)
    q="select uid, page_id, type from page_fan where uid in ("+ s5.chomp(',') + ") "
    @user5 = MiniFB.fql(cookies[:access_token], q)
    @user = @user1|@user2|@user3|@user4|@user5
    (0..@user.length-1).each do |e|
      sql =<<-SQL
       insert into fb_user_likes (fb_user_id, like_id, category) values (#{@user[e].uid},#{@user[e].page_id},'#{@user[e][:type]}')

      SQL
      r = ActiveRecord::Base.connection.execute sql
    end


    @likes = FbUserLike.find(:all, :select=> "distinct like_id", :conditions=> "like_name is null")
    listring = ""
    i=0
    @likes.each do |li|
      i+=1
      listring += li.like_id.to_s + ','
      if i% 500 == 0 || i==@likes.length
        #do the query on likes and then update likes table
        q = "select page_id,name from page where page_id in ("+ listring.chomp(',') + ") "
        logger.debug(q)
        @lis= MiniFB.fql(cookies[:access_token], q)
        @lis.each do |page|
          sql =<<-SQL
                update fb_user_likes set like_name = '#{page.name.gsub(/\\/, '\&\&').gsub(/'/, "''")}' where like_id = #{page.page_id}
          SQL
          r = ActiveRecord::Base.connection.execute sql
        end
        listring = ""
      end
    end





  end
=begin



    render :text=>'done'

  end
=end
  #PAGES
=begin
   
=end








  #@user = MiniFB.get(cookies[:access_token], 'me')
  #@response_hash = MiniFB.get(cookies[:access_token], 'me', :type=>'friends')
  #logger.debug(@response_hash)
  #s = ""
  #@response_hash.data.each do |d|
  #  s+=d.id.to_s + ','
  # end
  # logger.debug(s.chomp(','))
  #   logger.debug(d)
  # q = "SELECT eid,uid, rsvp_status from event_member where uid = 688967986 "
  #     logger.debug(q)
  # @user_hash =   MiniFB.fql(cookies[:access_token],q)
  #  logger.debug(p @user_hash)




  # @likes_hash =  MiniFB.get(cookies[:access_token], d.id, :type=>'likes')
        


  #@friend_hash =  MiniFB.get(cookies[:access_token], d.id, :type=>'events')
  


  #end


  


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
    if params[:code].present?
      logger.debug('fb_test')
      p params['code']
      access_token_hash = MiniFB.oauth_access_token(FB_APP_ID, CALLBACK_URL, 'a30c002eeb58d601fa6c3c84de076301', params[:code])
      @access_token = access_token_hash["access_token"]
      p @access_token
      cookies[:access_token] = @access_token
    end
    @user = MiniFB.get(cookies[:access_token], 'me')
    logger.debug('USERID:' +@user.id )
     self.current_user = User.find_by_fb_user_id(@user.id)
     redirect_to account_path
  end

  def new_test
    logger.debug(p MiniFB.scopes)
    @oauth_url = MiniFB.oauth_url(FB_APP_ID, # your Facebook App ID (NOT API_KEY)
      CALLBACK_URL, # redirect url
      :scope=>MiniFB.scopes.join(","))
    respond_to do |format|

      format.html {render :template => '/activities/new_test.html' }
    end
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

end