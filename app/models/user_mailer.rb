class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://hellopulse.com/activate/#{user.activation_code}"
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
      @recipients  = "#{user.email}"
      @from        = "admin@hellopulse.com"
      @subject     = "HELLOPULSE "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
