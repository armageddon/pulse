class AddGroupToActivity < ActiveRecord::Migration
    def self.up
       add_column :activities, :activity_group_name, :string
    end

    def self.down
        remove_column :activities, :activity_group_name
    end
  end

