class AddMailColumnsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :mail_matches, :datetime
    add_column :users, :mail_activities, :datetime
    add_column :users, :mail_photos, :datetime
  end

  def self.down
    remove_column :users, :mail_matches
    remove_column :users, :mail_activities
    remove_column :users, :mail_photos
  end
end
