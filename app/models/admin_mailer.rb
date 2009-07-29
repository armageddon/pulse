class AdminMailer < ActionMailer::Base
  
  def contact(params)
    @recipients = "dustym@gmail.com"
    @from = "dustym@gmail.com"
    @subject = "[HELLOPULSE] Contact from #{params[:from]}"
    
  end
end
