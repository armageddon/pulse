class CreateFbUserLikesEtc < ActiveRecord::Migration
  def self.up
     create_table "fb_users", :force => true do |t|
      t.integer   "fb_user_id",  :limit=>8
      t.string   "name"
      t.string   "gender"
      t.string   "relationship"
      t.string "birthday"
      t.integer "location_id",  :limit=>8
      t.datetime "date_added"
      t.datetime "date_updated"
    end

     create_table "fb_user_likes", :force => true do |t|
      t.integer   "fb_user_id"
      t.string   "category"
      t.integer   "like_id"
    end

  end

  def self.down
    drop_table "fb_users"
    drop_table "fb_user_likes"
  end
end
