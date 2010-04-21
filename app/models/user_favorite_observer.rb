class UserFavoriteObserver < ActiveRecord::Observer
  def after_create(user_favorite)
    friend = User.find(user_favorite.friend_id)
      RAILS_DEFAULT_LOGGER.info(user_favorite.friend_id.to_s + 'dffffffffffffffffffffffffffffff')
       RAILS_DEFAULT_LOGGER.info(friend.username)
       RAILS_DEFAULT_LOGGER.info(user_favorite.user.first_name)
    UserMailer.deliver_notification(user_favorite.user, friend) if user_favorite.user.status == 1 && friend.status==1
    
  end

end
