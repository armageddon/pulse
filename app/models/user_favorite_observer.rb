class UserFavoriteObserver < ActiveRecord::Observer
  def after_create(user_favorite)
    begin
    friend = User.find(user_favorite.friend_id)

    UserMailer.deliver_notification(friend , user_favorite.user) if user_favorite.user.status == 1 && friend.status==1 &&friend.note_messages=1
    rescue
      RAILS_DEFAULT_LOGGER.error('mailer error')
    end
    
  end

end
