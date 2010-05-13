class Event < ActiveRecord::Base

  belongs_to :place_activity
  belongs_to :user
  has_many :attendees



  validates_presence_of :user_id, :place_activity_id

  def title
    self.place_activity.activity.name
  end



end

