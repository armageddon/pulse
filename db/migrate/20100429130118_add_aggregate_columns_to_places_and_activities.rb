class AddAggregateColumnsToPlacesAndActivities < ActiveRecord::Migration
  def self.up
    add_column :places, :people_count, :integer, :default =>0
    add_column :places, :activity_count, :integer, :default =>0
    add_column :activities, :people_count, :integer, :default =>0
    add_column :activities, :place_count, :integer, :default =>0
  end

  def self.down
    remove_column :places, :people_count, :integer, :default =>0
    remove_column :places, :activity_count, :integer, :default =>0
    remove_column :activities, :people_count, :integer, :default =>0
    remove_column :activities, :place_count, :integer, :default =>0


  end
end
