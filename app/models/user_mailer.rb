class UserMailer < ActionMailer::Base
  include CrmData

  def invitations(user,user_list)
    headers["return-path"] = 'admin@hellopulse.com'
    @host = "http://www.hellopulse.com"
    @recipients  = "#{user_list}"
    @from        = "\"HelloPulse\" <admin@hellopulse.com>"
    @sent_on     = Time.now
    @subject = "You've been invited to HelloPulse"
    headers["return-path"] = 'admin@hellopulse.com'
    @recipients = user_list
    @user = user
  end

  def notification(user,friend)
    @user = user
    setup_email(user)
    @users = Array.new
    @happenings = Array.new
    
    @crm_activitites = CrmData.crm_activitites(@user,3)
    @meet_her_url = "http://aeser.co.uk/g/button-meet-her.jpg"
    @meet_him_url = "http://aeser.co.uk/g/button-meet-him.jpg"
    @friend=friend
    @crm_activitites.each do |u|
      @users << u
      @happenings << u.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
    end

    @subject = "Somebody likes you on HelloPulse!"
    @content_type =  "text/html"



  end


  def signup_notification(user)
    setup_email(user)
    @subject    += 'Welcome to HelloPulse'
    @body[:url]  = "http://hellopulse.com/activate/#{user.activation_code}"
    @content_type =  "text/html"
  end
  
  def partner_welcome(user)
    setup_email(user)
    @subject    = 'Welcome to HelloPulse'
  end

  def activity_reminder(user)
    setup_email(user)
     @meet_her_url = "http://aeser.co.uk/g/button-meet-her.jpg"
      @meet_him_url = "http://aeser.co.uk/g/button-meet-him.jpg"
    @user = user
    @subject = "What’s shaking on HelloPulse?"
    #todo: allow for men and women here
    @subject = "What’s shaking on HelloPulse?"
    @gender = @user.sex_preference == 1 ? 'men' : 'women'
    @crm_activitites = CrmData.crm_activitites(user,3)
    @users = Array.new
    @happenings = Array.new
    @crm_activitites.each do |u|
      @users << u
      @happenings << u.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
    end
    @content_type =  "text/html"
  end

  def photo_reminder(user)
    setup_email(user)
    @subject = "No photo, No action"
    @user = user
    #todo: allow for men and women here
    @gender = user.sex_preference == 1 ? 'men' : 'women'
    @crm_photos = CrmData.crm_photos(user,4)
    @user1 = @crm_photos[0]
    @user2  =  @crm_photos[1]
    @user3 = @crm_photos[2]
    @user4 = @crm_photos[3]
    @content_type =  "text/html"
  end

  def daily_matches(user)

    setup_email(user)
    @subject = "Here are the singles pulsing in London"
    @user = user
    @heading = "Great to have you on board. Check out your weekly matches!"
    @meet_her_url = "http://aeser.co.uk/g/button-meet-her.jpg"
    @meet_him_url = "http://aeser.co.uk/g/button-meet-him.jpg"
    #todo: allow for men and women here#
    #todo: ensure happening is the latest one
    @gender = user.sex_preference == 1 ? 'men' : 'women'
    @users = Array.new
    @happenings = Array.new
    CrmData.crm_matches(user,5).each do |u|
      @users << u
      @happenings << u.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
    end
    @content_type =  "text/html"
  end


  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://hellopulse.com/"
  end

  def new_password(user, new_password)
    setup_email(user)
    @subject    += 'Your new password'
    @body[:new_password]  = new_password
  end

  def message_received(recipient, sender)

    setup_email(User.find(recipient))
    @subject   = 'You have received a message from '  + User.find(sender).first_name
    @body[:sender]  = sender
    @body[:recipient] = recipient
    @body[:url] = 'http://www.hellopulse.com/?dest=message'
    @content_type =  "text/html"

  end

  protected
  def setup_email(user)
    headers["return-path"] = 'admin@hellopulse.com'
    @host = "http://www.hellopulse.com"
    @recipients  = "#{user.email}"
    @from        = "\"HelloPulse\" <admin@hellopulse.com>"
    @subject     = "HELLOPULSE "
    @sent_on     = Time.now
    @body[:user] = user
    

  end
end
