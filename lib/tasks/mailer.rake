namespace :mailer do
  task :photo => :environment do
    users = User.find(:all,:conditions=>"created_at  < DATE_ADD(CURRENT_DATE(), INTERVAL '1' DAY) and created_at > DATE_SUB(CURRENT_DATE(), INTERVAL '100' DAY) and mail_photos is null")
    users.each do |u|
      #UserMailer.deliver_photo_reminder(u)
      puts u.first_name
      RAILS_DEFAULT_LOGGER.info(u.first_name)
      u.mail_photos = Time.now
      u.save
    end

  end

  task :activity => :environment do
    users = User.find(:all,:conditions=>"created_at  < DATE_ADD(CURRENT_DATE(), INTERVAL '1' DAY) and created_at > DATE_SUB(CURRENT_DATE(), INTERVAL '100' DAY) and mail_photos is not null and mail_activities is null")
    users.each do |u|
      #UserMailer.deliver_photo_reminder(u)
      puts u.first_name
      RAILS_DEFAULT_LOGGER.info(u.first_name)
      u.mail_activities = Time.now
      u.save
    end
  end
end