class PlaceActivity < ActiveRecord::Base
  belongs_to :place
  belongs_to :activity
  has_many :user_place_activities
  belongs_to :events
  has_many :users, :through => :user_place_activities
  
  
  
def default_url
  self.place.place_activities.length >  self.activity.place_activities.length ? '/places/'+self.place.id.to_s : '/activities/'+self.activity.id.to_s
end
  
end
