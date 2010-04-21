class UserFavoriteObserver < ActiveRecord::Observer
  def after_create(user_favorite)
    friend = User.find(user_favorite.friend_id)
      RAILS_DEFAULT_LOGGER.debug(user_favorite.friend_id.to_s + 'dffffffffffffffffffffffffffffff')
       RAILS_DEFAULT_LOGGER.debug(friend.username)
    UserMailer.deliver_notification(user_favorite.user, friend) if user_favorite.user.status == 1 && friend.status==1
    
  end

end
