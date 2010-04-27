module CrmData

  
  def self.crm_matches(user,limit=5)
    if user.sex_preference!=nil && user.sex != nil && user.age_preference!=nil && user.sex != nil && user.age != nil
      @matches = User.paginate(:select=>'distinct users.*', :conditions => [
          "users.created_at >= ? and sex = ? AND sex_preference = ? AND status = 1 AND age in (?) AND age_preference in (?) AND users.id != ? and UPA.description is not null and UPA.description <> '' and users.icon_file_name is not null",
          mail_matches||='20090101',
          user.sex_preference,
          user.sex,
          [user.age_preference - 1, user.age_preference, user.age_preference + 1],
          [user.age - 1, user.age, user.age + 1],
          user.id
        ], :joins => 'inner join user_place_activities UPA on UPA.user_id = users.id', :order=>"UPA.created_at desc", :page=>1, :per_page=>limit)
    else
      #todo defaults if no matches (male/female/gay)
      @matches = User.paginate(:all,:conditions=>"1 = 0",:limit => 0,:page=>1, :per_page=>1)
    end
  end

  def self.crm_activitites(user,limit=5)
    if user.sex_preference!=nil && user.sex != nil && user.age_preference!=nil && user.sex != nil && user.age != nil
      @matches = User.paginate(:select=>'distinct users.*', :conditions => [
          "sex = ? AND sex_preference = ? AND status = 1 AND age in (?) AND age_preference in (?) AND users.id != ? and UPA.description is not null and UPA.description <> '' and users.icon_file_name is not null",
          user.sex_preference,
          user.sex,
          [user.age_preference - 1, user.age_preference, user.age_preference + 1],
          [user.age - 1, user.age, user.age + 1],
          user.id
        ], :joins => 'inner join user_place_activities UPA on UPA.user_id = users.id', :order=>"UPA.created_at desc", :page=>1, :per_page=>limit)
    else
      #todo defaults if no matches (male/female/gay)
      @matches = User.paginate(:all,:conditions=>"1 = 0",:limit => 0,:page=>1, :per_page=>1)
    end
    req = limit - @matches.length
    defs = User.find(:all,:select=>'distinct users.*', :conditions=>[
        "sex = ? and users.icon_file_name is not null and UPA.created_at < ? and UPA.description is not null and UPA.description <> ''"  ,
         user.sex_preference,Time.now -  (60 * 60 * 24)
      ],:joins => 'inner join user_place_activities UPA on UPA.user_id = users.id', :limit => req)
    defs.each do |u|
      @matches <<  u
    end
    @matches
  end


  def self.crm_photos(user,limit=5)
    if user.sex_preference!=nil && user.sex != nil && user.age_preference!=nil && user.sex != nil && user.age != nil
      @matches = User.find(:all, :conditions => [
          "sex = ? AND sex_preference = ? AND status = 1 AND age in (?) AND age_preference in (?) AND users.id != ? and users.icon_file_name is not null",
          user.sex_preference,
          user.sex,
          [user.age_preference - 1, user.age_preference, user.age_preference + 1],
          [user.age - 1, user.age, user.age + 1],
          user.id
        ], :order=>"users.created_at desc", :limit => limit)
    else
      #todo defaults if no matches (male/female/gay)
      @matches = User.paginate(:all,:conditions=>"1 = 0",:limit => 0,:page=>1, :per_page=>1)
    end
    #top up pics
    req = limit - @matches.length
    defs = User.find(:all, :conditions=>[
        "users.icon_file_name is not null and created_at < ? " ,
        Time.now -  (60 * 60 * 24)
      ], :limit => req)

    defs.each do |u|
      @matches <<  u
    end
    @matches
  end

  def self.mail_report
     sql =<<-SQL
        select DATE_FORMAT(created_at, '%W %d  %M %Y') as Date,
        sum(case type when 1 then 1 else 0 end) as Photo,
        sum(case type when 2 then 1 else 0 end) as Activity,
        sum(case type when 3 then 1 else 0 end) as Matches
        from mailer_messages
        group by DATE_FORMAT(created_at, '%W %d %M %Y')
        order by created_at desc
  SQL
     r = ActiveRecord::Base.connection.execute sql
     r
  end
end