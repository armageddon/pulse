class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  belongs_to :activity

  # validates_presence_of   :description
  validates_uniqueness_of :user_id, :scope => :place_id
  validates_presence_of   :user_id

end
