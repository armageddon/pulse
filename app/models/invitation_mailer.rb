class InvitationMailer < ActionMailer::Base

  def invitation(invitation)
    @from    = "\"HelloPulse\"<admin@hellopulse.com>"
    @subject = "You've been invited to HelloPulse"
    @recipients = invitation.email
    @body[:url]  = "www.hellopulse.com"
    @body[:user] = invitation.user
  end
end






