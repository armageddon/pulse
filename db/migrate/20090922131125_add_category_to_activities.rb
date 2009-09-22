class AddCategoryToActivities < ActiveRecord::Migration
    def self.up
       add_column :activities, :category, :string
    end

    def self.down
        remove_column :activities, :category
    end
  end
