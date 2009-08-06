class AddAttemptedGeocodeToPlaces < ActiveRecord::Migration
  def self.up
    add_column :places, :attempted_geocode, :boolean, :default => false
  end

  def self.down
    remove_column :places, :attempted_geocode
  end
end
