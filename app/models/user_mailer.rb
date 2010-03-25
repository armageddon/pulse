class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://hellopulse.com/activate/#{user.activation_code}"
  end

  def activity_reminder(user)
    setup_email(user)
    @user = user
    @subject = "What’s shaking on HelloPulse?"
    #todo: allow for men and women here
    @gender = user.sex_preference == 1 ? 'men' : 'women'
    @crm_matches = user.crm_matches(3)
    @user1 = @crm_matches[0]
    @user2  =  @crm_matches[1]
    @user3 = @crm_matches[2]
    @upa1 = @user1.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
    @upa2 = @user2.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
    @upa3 = @user3.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
    @content_type =  "text/html"
  end

  def photo_reminder(user)
     setup_email(user)
     @subject = "No photo, No action"
    @user = user
    #todo: allow for men and women here
    @gender = user.sex_preference == 1 ? 'men' : 'women'
    @crm_matches = user.crm_matches(4)
    @user1 = @crm_matches[0]
    @user2  =  @crm_matches[1]
    @user3 = @crm_matches[2]
    @user4 = @crm_matches[3]
    @content_type =  "text/html"
  end
  def daily_matches(user)
     setup_email(user)
     @subject = "Here are the singles pulsing in London"
    @user = user
    #todo: allow for men and women here#
    #todo: ensure happening is the latest one
    @gender = user.sex_preference == 1 ? 'men' : 'women'
    @crm_matches = user.crm_matches(5)
    @user1 = @crm_matches[0]
    @user2  =  @crm_matches[1]
    @user3 = @crm_matches[2]
    @user4 = @crm_matches[3]
    @user5 = @crm_matches[4]
    @upa1 = @user1.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
    @upa2 = @user2.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
    @upa3 = @user3.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
    @upa4 = @user4.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
    @upa5 = @user5.user_place_activities.find(:last,:conditions=>"description is not null and description <> ''")
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
   @subject   += 'You have received a mail from '  + User.find(sender).first_name
   @body[:sender]  = sender
   @body[:recipient] = recipient
   @body[:url] = 'http://hellopulse.com' + account_messages_path
  end
  protected
    def setup_email(user)
      @host = "http://174.143.128.98"
      @recipients  = "#{user.email}"
      @from        = "admin@hellopulse.com"
      @subject     = "HELLOPULSE "
      @sent_on     = Time.now
      @body[:user] = user


    end
end
