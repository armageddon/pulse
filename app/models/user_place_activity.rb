class UserPlaceActivity < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity
  belongs_to :place
  
  validates_uniqueness_of :user_id, :scope => [:place_id, :activity_id], :message => "You have already added this activity"
end
