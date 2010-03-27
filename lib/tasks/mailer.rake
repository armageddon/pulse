namespace :mailer do
  task :photo => :environment do
    users = User.find(:all,:conditions=>"created_at  < DATE_SUB(CURRENT_DATE(), INTERVAL '1' DAY) and mail_photos is null and icon_file_name is null ")
    users.each do |u|
      RAILS_DEFAULT_LOGGER.info(u.first_name)
      UserMailer.deliver_photo_reminder(u)
      puts u.first_name + ' ' + u.mail_photos.to_s
      t = User.find(u.id)
      t.mail_photos = Time.now
      t.save()
      
      puts t.first_name + ' ' + t.mail_photos.to_s
      t=nil
      m = MailerMessage.new
      m.user_id = u.id
      m.type = 1
      m.mail_text = 'txt'
      m.save
    end
  end

  task :activity => :environment do
    users = User.find(:all,:conditions=>"created_at  < DATE_SUB(CURRENT_DATE(), INTERVAL '1' DAY) and mail_photos is not null and mail_activities is null")
    users.each do |u|
      if u.user_place_activities.length == 0
        UserMailer.deliver_photo_reminder(u) 
        m = MailerMessage.new
        m.user_id = u.id
        m.type = 2
        m.mail_text = 'txt'
        m.save
        RAILS_DEFAULT_LOGGER.info(u.first_name)
        puts u.first_name
      end
      #update mail_activities date as we dont select this user again (we know has added an activity)
      u.mail_activities = Time.now
      u.save
    end
  end

  task :weekly => :environment do
    users = User.find(:all,:conditions=>"mail_matches  < DATE_SUB(CURRENT_DATE(), INTERVAL '7' DAY) ")
    users.each do |u|
      if u.crm_matches.length >1
        puts 'got matches - will send mail'
        u.mail_matches = Time.now
        u.save
        UserMailer.deliver_photo_reminder(u)
        puts u.first_name
        RAILS_DEFAULT_LOGGER.info(u.first_name)
        u.mail_activities = Time.now
        u.save
        m = MailerMessage.new
        m.user_id = u.id
        m.type = 2
        m.mail_text = 'txt'
        m.save
      end
    end
  end


end