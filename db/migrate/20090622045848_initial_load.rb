# pulse has gone through so many requirement changes
# it made sense to dump the initial migrations, as they were just confusing.

class InitialLoad < ActiveRecord::Migration
  def self.up
    create_table "activities", :force => true do |t|
      t.string   "name"
      t.string   "description"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "icon_file_name"
      t.string   "icon_content_type"
      t.string   "icon_file_size"
      t.string   "icon_updated_at"
    end

    create_table "categories", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "categories_places", :id => false, :force => true do |t|
      t.integer "category_id"
      t.integer "place_id"
    end

    create_table "events", :force => true do |t|
      t.integer  "user_id"
      t.integer  "place_id"
      t.datetime "when_time"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "duration"
    end

    create_table "favorites", :force => true do |t|
      t.integer  "user_id"
      t.integer  "place_id"
      t.string   "description"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "good_for"
    end

    create_table "invitations", :force => true do |t|
      t.string   "email"
      t.datetime "sent_at"
      t.integer  "user_id"
      t.string   "token"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "locations", :force => true do |t|
      t.string "name"
    end
    ["London", "New York"].each {|c| Location.create!(:name => c) }

    create_table "messages", :force => true do |t|
      t.integer  "sender_id"
      t.integer  "recipient_id"
      t.string   "subject"
      t.text     "body"
      t.datetime "read_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "places", :force => true do |t|
      t.string   "name"
      t.string   "building"
      t.string   "building_unit"
      t.string   "address"
      t.string   "city"
      t.string   "state"
      t.string   "zip"
      t.string   "neighborhood"
      t.string   "county"
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.float    "latitude"
      t.float    "longitude"
      t.integer  "location_id"
      t.string   "phone"
      t.string   "website"
      t.string   "import_id"
      t.string   "import_source"
      t.string   "icon_file_name"
      t.string   "icon_content_type"
      t.string   "icon_file_size"
      t.string   "icon_updated_at"
    end

    create_table "user_activities", :force => true do |t|
      t.integer  "user_id"
      t.integer  "activity_id"
      t.string   "description"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "user_pictures", :force => true do |t|
      t.string   "picture_file_name"
      t.string   "picture_content_type"
      t.string   "picture_file_size"
      t.string   "picture_updated_at"
    end

    create_table "users", :force => true do |t|
      t.string   "email"
      t.string   "first_name"
      t.string   "username"
      t.integer  "sex"
      t.integer  "age"
      t.integer  "age_preference"
      t.integer  "sex_preference"
      t.string   "description"
      t.string   "timezone"
      t.string   "crypted_password",          :limit => 40
      t.string   "salt",                      :limit => 40
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "remember_token",            :limit => 40
      t.datetime "remember_token_expires_at"
      t.string   "activation_code",           :limit => 40
      t.datetime "activated_at"
      t.string   "state",                                   :default => "passive"
      t.datetime "deleted_at"
      t.boolean  "admin"
      t.integer  "profile_views",                           :default => 0
      t.integer  "location_id"
      t.string   "icon_file_name"
      t.string   "icon_content_type"
      t.string   "icon_file_size"
      t.string   "icon_updated_at"
    end

  end

  def self.down
  end
end
