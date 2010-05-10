class Event < ActiveRecord::Base

  belongs_to :place_activities
  belongs_to :user
  has_many :attendees


  validates_presence_of :user_id, :place_id

  def title
    'Eating at ' + self.place.name
    end



end

