class AddTestCoumnToUsers < ActiveRecord::Migration
  def self.up
     add_column :users , :c, :integer, :default => 1   
   end

   def self.down
      remove_column :c , :status

   end
end
