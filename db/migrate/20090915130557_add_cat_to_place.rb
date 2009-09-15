class AddCatToPlace < ActiveRecord::Migration
    def self.up
      add_column :places, :category, :string
    end

    def self.down
      remove_column :places, :category
    end
  end