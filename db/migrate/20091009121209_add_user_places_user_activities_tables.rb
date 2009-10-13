class AddUserPlacesUserActivitiesTables < ActiveRecord::Migration
    def self.up
      create_table "user_activities", :force => true do |t|
        t.integer   "user_id"
        t.integer   "activity_id"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
      create_table "user_places", :force => true do |t|
        t.integer   "user_id"
        t.integer   "place_id"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
    end

    def self.down
    end
  end
