class UserFavorite < ActiveRecord::Base
  belongs_to :user
  
  validates_uniqueness_of :user_id, :scope => [:friend_id], :message => "You have already added this person"
  

  
end
