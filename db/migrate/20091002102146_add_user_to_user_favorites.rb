class AddUserToUserFavorites < ActiveRecord::Migration
    def self.up
       remove_column :user_favorites , :name
       add_column :user_favorites, :user_id, :integer
       add_column :user_favorites, :friend_id, :integer
    end

    def self.down
        add_column :user_favorites, :name, :string
        remove_column :user_favorites, :user_id
        remove_column :user_favorites, :friend_id
    end
  end
