class AddDescToUserPlaceActivities < ActiveRecord::Migration
  def self.up
    add_column :user_place_activities, :description, :string
  end

  def self.down
    remove_column :user_place_activities, :description
  end
end
