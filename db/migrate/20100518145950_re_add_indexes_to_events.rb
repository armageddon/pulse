class ReAddIndexesToEvents < ActiveRecord::Migration
  def self.up
    add_index :fb_user_events, :event_location
    add_index :fb_user_events, :event_name
    add_index :fb_user_events, :fb_user_id

  end

  def self.down
    remove_index :fb_user_events, :event_location
    remove_index :fb_user_events, :event_name
    remove_index :fb_user_events, :fb_user_id

  end
end
