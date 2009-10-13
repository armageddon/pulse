class UserActivity < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity
  
  validates_uniqueness_of :user_id, :scope => [ :activity_id], :message => "You have already added this activity"
end