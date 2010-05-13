class CreateFbUserEventTable < ActiveRecord::Migration
  def self.up

    create_table "fb_user_events", :force => true do |t|
      t.integer   "user_id"
      t.string   "user_name"
      t.integer   "event_id"
      t.string   "event_location"
      t.string "event_name"
      t.datetime "event_start"
      t.datetime "event_end"
      t.datetime "date_added"
      t.datetime "date_updated"
    end
  end

  def self.down
    drop_table "fb_user_events"
  end
end
