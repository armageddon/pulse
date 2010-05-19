class CreateFbFriendsTable < ActiveRecord::Migration
  def self.up
     create_table "fb_friends", :force => true do |t|
      t.integer   "fb_user_id1",  :limit=>8
      t.integer   "fb_user_id2",  :limit=>8
      t.boolean "is_friend"
    end
  end
 

  def self.down
    drop_table "fb_friends"
  end

end
