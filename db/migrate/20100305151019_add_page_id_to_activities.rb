class AddPageIdToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :fb_page_id, :integer
  end

  def self.down
    remove_column :activities, :fb_page_id
  end
end
