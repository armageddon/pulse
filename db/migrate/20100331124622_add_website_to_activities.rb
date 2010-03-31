class AddWebsiteToActivities < ActiveRecord::Migration
  def self.up
      add_column :activities, :website, :string
  end

  def self.down
        remove_column :activities, :website
  end
end
