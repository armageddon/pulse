class InvitationMailer < ActionMailer::Base

  def invitation(invitation)
    @from    = "admin@hellopulse.com"
    @subject = "You've been invited to HelloPulse"
    @recipients = invitation.email
    @body[:url]  = "http://staging.hellopulse.com/redeem/#{invitation.token}"
    @body[:user] = invitation.user
  end
end






