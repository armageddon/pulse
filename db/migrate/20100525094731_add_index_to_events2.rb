class AddIndexToEvents2 < ActiveRecord::Migration
  def self.up
       add_index :fb_user_events, :event_id
       add_index :fb_user_likes, :like_id
  end

  def self.down
    remove_index :fb_user_events, :event_id
  end
end
