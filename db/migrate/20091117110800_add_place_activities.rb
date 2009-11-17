class AddPlaceActivities < ActiveRecord::Migration
    def self.up
      create_table :place_activities do |t|
        t.integer   :activity_id
        t.integer   :place_id
        
      end
    end
    
    def self.down
      drop_table :place_activities
    end
  end
