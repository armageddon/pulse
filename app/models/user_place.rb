class UserPlace < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  
  validates_uniqueness_of :user_id, :scope => [:place_id], :message => "You have already added this place"
end