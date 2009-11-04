class AddDescToUserPlaceActivities < ActiveRecord::Migration
  def self.up
    create_table "user_place_activities", :force => true do |t|
      t.integer   "user_id"
      t.integer   "place_id"
      t.integer   "activity_id"
      t.integer   "description"
      t.datetime "created_at"
      t.datetime "updated_at"

    end 
  end

  def self.down

  end
end
