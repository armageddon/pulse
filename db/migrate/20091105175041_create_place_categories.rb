class CreatePlaceCategories < ActiveRecord::Migration
    def self.up
      create_table :place_categories do |t|
        t.string   :description
      end
      add_column :places, :place_category_id, :integer
    end
    
    def self.down
      drop_table :place_categories
      remove_column :places, :place_category_id
    end
  end