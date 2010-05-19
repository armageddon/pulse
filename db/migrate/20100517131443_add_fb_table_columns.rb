class AddFbTableColumns < ActiveRecord::Migration
  def self.up
    rename_column :fb_user_events, :user_id, :fb_user_id
    add_column :fb_users, :fb_user_source_id, :integer,  :limit=>8
  end

  def self.down
    rename_column :fb_user_events, :fb_user_id, :user_id
    remove_column :fb_users, :fb_user_source_id
  end
end
