class AddNotificationSettingsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :note_matches, :boolean, :default => 1
    add_column :users, :note_tips, :boolean, :default => 1
    add_column :users, :note_messages, :boolean, :default => 1
  end

  def self.down
    remove_column :users, :note_matches
    remove_column :users, :note_tips
    remove_column :users, :note_messages
  end
end
