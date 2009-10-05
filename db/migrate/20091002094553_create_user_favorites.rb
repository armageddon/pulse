class CreateUserFavorites < ActiveRecord::Migration
  def self.up
    create_table "user_favorites", :force => true do |t|
      t.integer   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
  end
end
