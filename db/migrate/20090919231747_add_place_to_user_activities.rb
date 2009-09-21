class AddPlaceToUserActivities < ActiveRecord::Migration
    def self.up
       add_column :user_activities, :place_id, :integer
    end

    def self.down
        remove_column :user_activities, :place_id
    end
  end
