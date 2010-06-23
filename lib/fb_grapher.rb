
module FbGrapher
  require 'mini_fb'
  def self.logger
    RAILS_DEFAULT_LOGGER
  end


  def self.graph_base
        "https://graph.facebook.com/"
    end

  def self.oauth_url(app_id, redirect_uri, options={})
    logger.debug('OWN OUTH URL GEN')
    oauth_url = "#{graph_base}oauth/authorize"
    oauth_url << "?client_id=#{app_id}"
    oauth_url << "&redirect_uri=#{URI.escape(redirect_uri)}"
    # oauth_url << "&scope=#{options[:scope]}" if options[:scope]
    oauth_url << ("&" + options.each.map { |k, v| "%s=%s" % [k, v] }.join('&')) unless options.empty?
    oauth_url << '&display=popup'
     oauth_url << '&type=client_cred'
    oauth_url
  end

  def self.scopes
    all_scopes = []
    scope_names = ["about_me", "activities", "birthday", "education_history", "events", "groups",
      "interests", "likes","hometown",
      "location", "notes", "online_presence", "relationships",
      "status",  "website", "work_history"]
    scope_names.each { |x| all_scopes << "user_" + x; all_scopes << "friends_" + x }
    all_scopes << "read_friendlists"
    # all_scopes << "read_stream"
    all_scopes << "offline_access"
    all_scopes << "email"
    all_scopes
   
  end

  def self.pull(access_token)
    logger.info('TOKEN: ' + access_token)
    logger.info('FB_PULL START: ' + DateTime.now.to_s)
    q = "SELECT eid,uid, rsvp_status from event_member where uid = 688967986"

    @user = MiniFB.get(access_token, 'me')
    logger.info(@user.name)
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

    @response_hash = MiniFB.get(access_token, @user.id, :type=>'friends')
    logger.info(p @response_hash)
    logger.info('FB_PULL GOT FRIENDS ' + DateTime.now.to_s)
    # logger.debug(@response_hash.data.length)
    s1 = ""
    s2 = ""
    s3 = ""
    s4 = ""
    s5 = ""
    @response_hash.data.each do |d|
      s1 +=d.id.to_s + ',' if d.id.to_i%5 == 0
      s2 +=d.id.to_s + ',' if d.id.to_i%5 == 1
      s3 +=d.id.to_s + ',' if d.id.to_i%5 == 2
      s4 +=d.id.to_s + ',' if d.id.to_i%5 == 3
      s5 +=d.id.to_s + ',' if d.id.to_i%5 == 4
    end
    logger.info('FB_PULL MODED FREINDS ' + DateTime.now.to_s)
    # logger.debug(s1.chomp(','))

    q="select uid, first_name, name, current_location, meeting_for, meeting_sex, religion, relationship_status, birthday_date, birthday , sex , hometown_location from user where uid in ("+ s1.chomp(',') + ") "
    @users1 = MiniFB.fql(access_token, q)
    logger.info('FB_PULL  FRIENDS 1 ' + DateTime.now.to_s)
    q="select uid, first_name, name, current_location, meeting_for, meeting_sex, religion, relationship_status, birthday_date, birthday , sex , hometown_location from user where uid in ("+ s2.chomp(',') + ") "
    @users2= MiniFB.fql(access_token, q)
    logger.info('FB_PULL  FRIENDS 2 ' + DateTime.now.to_s)
    q="select uid, first_name, name, current_location, meeting_for, meeting_sex, religion, relationship_status, birthday_date, birthday , sex , hometown_location from user where uid in ("+ s3.chomp(',') + ") "
    @users3 = MiniFB.fql(access_token, q)
    logger.info('FB_PULL  FRIENDS 3 ' + DateTime.now.to_s)
    q="select uid, first_name, name, current_location, meeting_for, meeting_sex, religion, relationship_status, birthday_date, birthday , sex , hometown_location from user where uid in ("+ s4.chomp(',') + ") "
    @users4 = MiniFB.fql(access_token, q)
    logger.info('FB_PULL  FRIENDS 4 ' + DateTime.now.to_s)
    q="select uid, first_name, name, current_location, meeting_for, meeting_sex, religion, relationship_status, birthday_date, birthday , sex , hometown_location from user where uid in ("+ s5.chomp(',') + ") "
    @users5 = MiniFB.fql(access_token, q)
    logger.info('FB_PULL  FRIENDS 5 ' + DateTime.now.to_s)
    @users1 = @users1 == nil || @users1.length==0 ?   Array.new : @users1.class!=Array ? @users1.data : @users1
    @users2 = @users2 == nil || @users2.length==0 ?  Array.new : @users2.class!=Array ? @users2.data : @users2
    @users3 =@users3 == nil || @users3.length==0 ?  Array.new : @users3.class!=Array ? @users3.data : @users3
    @users4 =@users4 == nil || @users4.length==0 ?  Array.new : @users4.class!=Array ? @users4.data : @users4
    @users5 = @users5 == nil || @users5.length==0 ?  Array.new : @users5.class!=Array ? @users5.data : @users5

    @users = @users1|@users2|@users3|@users4|@users5

    (0..@users.length-1).each do |e|

      usr = @users[e]
      # logger.debug(usr)
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
    logger.info('FB_PULL  INSERTED AND CREATED FRIENDS ' + DateTime.now.to_s)

    #EVENTS
    q="select uid, eid, rsvp_status  from event_member where uid in ("+ s1.chomp(',') + ") and rsvp_status in  ('attending','unsure')"
    @events1 = MiniFB.fql(access_token, q)
    q="select uid, eid, rsvp_status from event_member where uid in ("+ s2.chomp(',') + ") and rsvp_status in  ('attending','unsure')"
    @events2 = MiniFB.fql(access_token, q)
    q="select uid, eid, rsvp_status from event_member where uid in ("+ s3.chomp(',') + ") and rsvp_status in  ('attending','unsure')"
    @events3 = MiniFB.fql(access_token, q)
    q="select uid, eid, rsvp_status from event_member where uid in ("+ s4.chomp(',') + ") and rsvp_status in  ('attending','unsure')"
    @events4 = MiniFB.fql(access_token, q)
    q="select uid, eid, rsvp_status from event_member where uid in ("+ s5.chomp(',') + ") and rsvp_status in  ('attending','unsure')"
    @events5 = MiniFB.fql(access_token, q)

    @events1 = @events1 == nil || @events1.length==0 ?   Array.new : @events1.class!=Array ? @events1.data : @events1
    @events2 = @events2 == nil || @events2.length==0 ?  Array.new : @events2.class!=Array ? @events2.data : @events2
    @events3 = @events3 == nil || @events3.length==0 ?  Array.new : @events3.class!=Array ? @events3.data : @events3
    @events4 = @events4 == nil || @events4.length==0 ?  Array.new : @events4.class!=Array ? @events4.data : @events4
    @events5 = @events5 == nil || @events5.length==0 ?  Array.new : @events5.class!=Array ? @events5.data : @events5




    @events = @events1|@events2|@events3|@events4|@events5
    # logger.debug(@events)
    logger.info('FB_PULL  EVENTS ALL 1 ' + DateTime.now.to_s)
    (0..@events.length-1).each do |e|
      sql =<<-SQL
       insert into fb_user_events (fb_user_id, event_id, rsvp_status) values (#{@events[e].uid},#{@events[e].eid},'#{@events[e].rsvp_status}')
      SQL
      r = ActiveRecord::Base.connection.execute sql
    end
    logger.info('FB_PULL  INSERTED EVENTS ' + DateTime.now.to_s)
    @event_mems = FbUserEvent.find(:all, :select=> "distinct event_id", :conditions=> "event_name is null")
    listring = ""
    i=0

    @event_mems.each do |li|
      i+=1
      listring += li.event_id.to_s + ','
      if i% 500 == 0 || i == @event_mems.length
        #logger.debug(listring)
        #do the query on likes and then update likes table
        q = "select eid,name,location,start_time, end_time,event_type, event_subtype, venue from event where eid in ("+ listring.chomp(',') + ") "
        #logger.debug(q)
        @lis= MiniFB.fql(access_token, q)
        #logger.debug(@lis)
        #update vent here

        @lis.each do |evnt|
          #  logger.debug(evnt.venue)
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
    logger.info('FB_PULL  UPDATED EVENTS ' + DateTime.now.to_s)

    q="select uid, page_id, type from page_fan where uid in ("+ s1.chomp(',') + ") "
    @user1 = MiniFB.fql(access_token, q)
    q="select uid, page_id, type from page_fan where uid in ("+ s2.chomp(',') + ") "
    @user2 = MiniFB.fql(access_token, q)
    q="select uid, page_id, type from page_fan where uid in ("+ s3.chomp(',') + ") "
    @user3 = MiniFB.fql(access_token, q)
    q="select uid, page_id, type from page_fan where uid in ("+ s4.chomp(',') + ") "
    @user4 = MiniFB.fql(access_token, q)
    q="select uid, page_id, type from page_fan where uid in ("+ s5.chomp(',') + ") "
    @user5 = MiniFB.fql(access_token, q)

    @user1 = @user1 == nil || @user1.length==0 ?   Array.new : @user1.class!=Array ? @users.data : @user1
    @user2 = @user2 == nil || @user2.length==0 ?  Array.new : @user2.class!=Array ? @users.data : @user2
    @user3 =@user3 == nil || @user3.length==0 ?  Array.new : @user3.class!=Array ? @users.data : @user3
    @user4 =@user4 == nil || @user4.length==0 ?  Array.new : @users.class!=Array ? @users.data : @user4
    @user5 =@user5 == nil || @user5.length==0 ?  Array.new : @users.class!=Array ? @users.data : @user5


    @user = @user1|@user2|@user3|@user4|@user5
    logger.info('FB_PULL  LIKES ' + DateTime.now.to_s)
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
        # logger.debug(q)
        @lis= MiniFB.fql(access_token, q)

        @lis.each do |page|
          if page.name != nil
            sql =<<-SQL
                update fb_user_likes set like_name = '#{page.name.gsub(/\\/, '\&\&').gsub(/'/, "''")}' where like_id = #{page.page_id}
            SQL
            r = ActiveRecord::Base.connection.execute sql
          end
        end

        listring = ""
      end
    end

    logger.info('FB_PULL   UPDATED LIKES ' + DateTime.now.to_s)

  end


end



