class AdminMailer < ActionMailer::Base
  
  def contact(recipient, subject, message, love, change, tell,user_first_name, user_id, user_email, sent_at = Time.now)
    @recipients = "hellopulse@googlemail.com"
    @from = "hellopulse@googlemail.com"
    @subject = "[HELLOPULSE] Contact from " + user_first_name + " email: " + user_email + " id: " + user_id.to_s
    @love = love
    @change = change
    @tell = tell
  end
end
