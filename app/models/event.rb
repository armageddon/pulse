class Event < ActiveRecord::Base

  belongs_to :place_activity
  belongs_to :user
  has_many :attendees



  validates_presence_of :user_id, :place_activity_id

  def title
    self.place_activity.activity.name + ' at ' + self.place_activity.place.name
  end

  def url
    '/user_events/'+self.id.to_s
  end


end

