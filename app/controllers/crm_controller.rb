class CrmController < ApplicationController

  def index
    if current_user.admin
      @users = User.find(:all)
      @usersmatches_note_matches = User.find(:all, :conditions=> 'note_matches = 1')
      @usersmatches = User.find(:all,:conditions=>"(mail_matches  < DATE_SUB(CURRENT_DATE(), INTERVAL '7' DAY) or mail_matches is null ) and note_matches = 1")
      @user_match_ids = Array.new
      @usersmatches.each do |u|
        @user_match_ids << u.id
      end

      @nophotousers = User.find(:all, :conditions=>"icon_file_name is null ")
      @nophotousers_note_tips = User.find(:all, :conditions=>"icon_file_name is null and note_tips = 1")
      @nophotousersphotos = User.find(:all, :conditions=>"( mail_photos  < DATE_SUB(CURRENT_DATE(), INTERVAL '14' DAY)
                                                                                    or mail_photos is null)
                                                                                    and  created_at  < DATE_SUB(CURRENT_DATE(), INTERVAL '1' DAY)
                                                                                    and icon_file_name is null and note_tips =1")
      @user_photo_ids = Array.new
      @nophotousersphotos.each do |u|
        @user_photo_ids << u.id
      end

      @noactivityusers = User.find(:all, :joins=>"left join user_place_activities UPA on UPA.user_id = users.id", :conditions=>"UPA.user_id is null")
      @noactivityusers_note_tips = User.find(:all, :joins=>"left join user_place_activities UPA on UPA.user_id = users.id", :conditions=>"UPA.user_id is null and note_tips = 1")
      @noactivityusersactivities = User.find(:all, :conditions=>"(mail_activities  < DATE_SUB(CURRENT_DATE(), INTERVAL '14' DAY)
                                                                                        or mail_activities is null)
                                                                                        and  users.created_at  < DATE_SUB(CURRENT_DATE(), INTERVAL '1' DAY)
                                                                                        and note_tips =1
                                                                                        and UPA.user_id is null",
        :joins=>"left join user_place_activities UPA on UPA.user_id = users.id"
      )
      @user_activity_ids = Array.new
      @noactivityusersactivities.each do |u|
        @user_activity_ids << u.id
      end
      render :template => 'crm/admin', :layout=>false
    else
      render text => 'Not authorized', :layout=>false
    end  
  end

  #TODO: use initialiser for MailerMessage
  #TOTO: send back relevant code (success/failure) - not done
  def match
    if current_user.admin
      u = User.find(params[:id])
      u.mail_matches = Time.now
      u.save
      logger.debug(params[:id])
      UserMailer.deliver_daily_matches(u)
      m = MailerMessage.new
      m.user_id = u.id
      m.type = 3
      m.mail_text = 'txt'
      m.save
      render :text => 'done'
    end
  end

  def photo
    if current_user.admin
      u = User.find(params[:id])
      UserMailer.deliver_photo_reminder(u)
      puts u.first_name + ' ' + u.mail_photos.to_s
      t = User.find(u.id)
      t.mail_photos = Time.now.to_time.advance(:days=>14).to_date
      t.save()
      t=nil
      m = MailerMessage.new
      m.user_id = u.id
      m.type = 1
      m.mail_text = 'txt'
      m.save
      render :text => 'done'
    end
  end
 
  def activity
    if current_user.admin
      u = User.find(params[:id])
      UserMailer.deliver_activity_reminder(u)
      puts u.first_name + ' ' + u.mail_photos.to_s
      t = User.find(u.id)
      t.mail_activities = Time.now.to_time.advance(:days=>14).to_date
      t.save()
      t=nil
      m = MailerMessage.new
      m.user_id = u.id
      m.type = 2
      m.mail_text = 'txt'
      m.save
      render :text => 'done'
    end
  end
end




