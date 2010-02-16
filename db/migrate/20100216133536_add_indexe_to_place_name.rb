class AddIndexeToPlaceName < ActiveRecord::Migration
  def self.up
    add_index :places, :name
  end

  def self.down
    remove_index  :places, :name
  end
end
