class AddUrlToPlaceActivity < ActiveRecord::Migration
   def self.up
    add_column :place_activities, :url, :string
  end

  def self.down
    remove_column :place_activities, :url
  end
end
