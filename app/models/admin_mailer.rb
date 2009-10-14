class AdminMailer < ActionMailer::Base
  
  def contact(recipient, subject, message, sent_at = Time.now)
    @recipients = "hellopulse@googlemail.com"
    @from = "hellopulse@googlemail.com"
    @subject = "[HELLOPULSE] Contact from "
    
  end
end
