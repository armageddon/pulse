class PlaceActivity < ActiveRecord::Base
  belongs_to :place
  belongs_to :activity
  has_many :user_place_activities
  has_many :users, :through => :user_place_activities
end
