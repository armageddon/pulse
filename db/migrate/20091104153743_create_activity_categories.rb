class CreateActivityCategories < ActiveRecord::Migration
  def self.up
    create_table :activity_categories do |t|
      t.string   :description
    end
  end
  def self.down
    drop_table :activity_categories
  end
end