class AddAdminToVisitors < ActiveRecord::Migration
    def self.up
     add_column :visitors, :admin, :int
  end

  def self.down
    remove_column :visitors, :admin
  end
end
