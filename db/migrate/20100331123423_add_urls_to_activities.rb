class AddUrlsToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :fb_page_url, :string
    add_column :places, :fb_page_url, :string
  end

  def self.down
   remove_column :activities, :fb_page_url, :string
    remove_column :places, :fb_page_url, :string
  end
end
