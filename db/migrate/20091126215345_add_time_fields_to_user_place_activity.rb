class AddTimeFieldsToUserPlaceActivity < ActiveRecord::Migration
  def self.up
    add_column :user_place_activities , :time_of_day, :integer
    add_column :user_place_activities , :day_of_week, :integer
  end

  def self.down
     remove_column :user_place_activities , :time_of_day
     remove_column :user_place_activities , :day_of_week

  end
end
