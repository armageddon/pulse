class AdminMailer < ActionMailer::Base
  
  def contact(recipient, subject, message, sent_at = Time.now)
    @recipients = "admin@hellopulse.com"
    @from = "admin@hellopulse.com"
    @subject = "[HELLOPULSE] Contact from "
    
  end
end
