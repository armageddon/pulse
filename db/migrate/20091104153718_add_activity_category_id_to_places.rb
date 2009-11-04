class AddActivityCategoryIdToPlaces < ActiveRecord::Migration
   def self.up
       add_column :places, :activity_category_id, :integer
    end

    def self.down
        remove_column :places, :activity_category_id
    end
  end
