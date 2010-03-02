class AddCodeToActivities < ActiveRecord::Migration
  def self.up
  add_column :activities, :auth_code, :string

end

def self.down
  remove_column :activities, :auth_code

end
end
