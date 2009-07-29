class InvitationObserver < ActiveRecord::Observer

  def after_create(invite)
    InvitationMailer.deliver_invitation(invite)
  end

end
