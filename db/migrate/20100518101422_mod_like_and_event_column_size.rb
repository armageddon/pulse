class ModLikeAndEventColumnSize < ActiveRecord::Migration
  def self.up
    change_table :fb_user_events do |t|
      t.change :event_id , :integer, :limit=>8
    end
    change_table :fb_user_likes do |t|
      t.change :like_id , :integer, :limit=>8
    end
  end

  def self.down
  end
end
