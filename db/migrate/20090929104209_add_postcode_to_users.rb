class AddPostcodeToUsers < ActiveRecord::Migration
    def self.up
       add_column :users, :postcode, :string
    end

    def self.down
        remove_column :users, :postcode
    end
  end
