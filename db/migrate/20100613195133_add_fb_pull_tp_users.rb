class AddFbPullTpUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_pull, :boolean, :default =>false
  end

  def self.down
    remove_column :users, :fb_pull
  end
end
