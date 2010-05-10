class AddExtraEventFields < ActiveRecord::Migration
  def self.up
    add_column :events, :place_activity_id, :string
    create_table "attendees", :force => true do |t|
      t.integer   "event_id"
      t.string   "user_id"
      t.integer   "attendee_type"
      t.integer   "attendee_response"
      t.datetime "created_at"
      t.datetime "updated_at"

    end
  end

  def self.down
   remove_column :events, :place_activity_id
   drop_table :attendees
  end
end
