class AddHeightBodyToUsers < ActiveRecord::Migration
  def self.up
     add_column :users , :height, :integer, :default => 0
     add_column :users, :body_type, :integer, :default => 0
   end

   def self.down
      remove_column :users , :height
      remove_column :users , :body_type

   end
end
