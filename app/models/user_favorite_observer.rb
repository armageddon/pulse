class UserFavoriteObserver < ActiveRecord::Observer
  def after_create(user_favorite)

    UserMailer.deliver_notification(user_favorite.user, user_favorite.friend) if user_favorite.user.status == 1 && user_favorite.friend.status==1
    
  end

end
