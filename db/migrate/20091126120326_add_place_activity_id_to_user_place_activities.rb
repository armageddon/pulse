class AddPlaceActivityIdToUserPlaceActivities < ActiveRecord::Migration
  def self.up
    add_column :user_place_activities , :place_activity_id, :integer
  end

  def self.down
     remove_column :user_place_activities , :place_activity_id

  end
end