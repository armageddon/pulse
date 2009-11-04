class CreateActivityCategories2 < ActiveRecord::Migration
   def self.up
       remove_column :places, :activity_category_id
       add_column :activities, :activity_category_id, :integer
    end

    def self.down
        add_column :places, :activity_category_id, :integer
        remove_column :activities, :activity_category_id
    end
  end
