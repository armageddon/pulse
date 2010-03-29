class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_signup_notification(user) if user.status == 1
    UserMailer.deliver_partner_welcome(user) if user.status == 3
  end

  def after_save(user)
    #UserMailer.deliver_activation(user) if user.recently_activated?
  end
end
  