class CreateUpaEvents < ActiveRecord::Migration
  def self.up
    create_table :place_activity_events do |t|
      t.integer  :place_activity_id, :limit => 8
      t.string    :image_file
      t.string    :header
      t.string    :description
      t.timestamps
    end
  end

  def self.down
    drop_table :place_activity_events
  end
end