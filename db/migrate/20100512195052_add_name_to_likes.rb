class AddNameToLikes < ActiveRecord::Migration
  def self.up

    add_column :fb_user_likes, :like_name, :string
  end

  def self.down
    remove_column :fb_user_likes, :like_name
  end
end
