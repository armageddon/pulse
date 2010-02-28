class AddUserColumnsToActivities < ActiveRecord::Migration
 def self.up
  add_column :activities, :create_user_id, :integer
  add_column  :activities, :admin_user_id, :integer
end

def self.down
  remove_column :activities, :create_user_id
  remove_column :activities, :admin_user_id
end
end
