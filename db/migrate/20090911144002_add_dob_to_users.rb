class AddDobToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :dob, :datetime
  end

  def self.down
    remove_column :places, :datetime
  end
end
