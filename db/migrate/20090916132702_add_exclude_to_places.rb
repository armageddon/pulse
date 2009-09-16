class AddExcludeToPlaces < ActiveRecord::Migration
  def self.up
     add_column :places, :exclude, :boolean, :default => false
  end

  def self.down
      remove_column :places, :exclude
  end
end
