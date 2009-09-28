class UserActivity < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity
  belongs_to :place
end
