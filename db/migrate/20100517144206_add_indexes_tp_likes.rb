class AddIndexesTpLikes < ActiveRecord::Migration
   def self.up
    add_index :fb_user_likes, :category
    add_index :fb_user_likes, :like_name
    add_index :fb_user_likes, :fb_user_id

  end

  def self.down
    remove_index :fb_user_likes, :category
    remove_index :fb_user_likes, :like_name
    remove_index :fb_user_likes, :fb_user_id


  end
end
