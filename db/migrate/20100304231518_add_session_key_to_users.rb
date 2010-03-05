class AddSessionKeyToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_session_key, :string
  end

  def self.down
    remove_column :users, :fb_session_key
  end
end
