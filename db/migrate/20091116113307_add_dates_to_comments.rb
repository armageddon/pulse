class AddDatesToComments < ActiveRecord::Migration
  def self.up
    add_column :comments , :updated_at, :datetime 
    add_column :comments , :created_at, :datetime 
  end

  def self.down
     remove_column :comments , :updated_at 
      remove_column :comments , :created_at
  end
end
