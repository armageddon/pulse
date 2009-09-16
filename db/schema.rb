# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090916135020) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.string   "icon_file_size"
    t.string   "icon_updated_at"
    t.string   "place_id"
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

  create_table "ldc", :force => true do |t|
    t.string  "LDC_ID",             :limit => 512
    t.string  "b_NameFull",         :limit => 512
    t.string  "ad_Building_Unit",   :limit => 512
    t.string  "ad_Building",        :limit => 512
    t.string  "ad_Building_careof", :limit => 512
    t.string  "ad_StreetNumber",    :limit => 512
    t.string  "ad_Street",          :limit => 512
    t.string  "ad_Zip",             :limit => 512
    t.string  "area_name",          :limit => 512
    t.string  "ad_City",            :limit => 512
    t.string  "ad_county",          :limit => 512
    t.string  "bus_telephone",      :limit => 512
    t.string  "website_name",       :limit => 512
    t.string  "b_multipleID",       :limit => 512
    t.string  "b_multipleName",     :limit => 512
    t.string  "cat_ID1",            :limit => 512
    t.string  "cat_Name1",          :limit => 512
    t.string  "cat_ID2",            :limit => 512
    t.string  "cat_Name2",          :limit => 512
    t.string  "transport_name",     :limit => 512
    t.string  "transport_carrier",  :limit => 512
    t.text    "export_description"
    t.string  "feature_names",      :limit => 512
    t.string  "feature_price",      :limit => 512
    t.boolean "exclude",                           :default => false
  end

  add_index "ldc", ["id"], :name => "idx_id"

  create_table "locations", :force => true do |t|
    t.string "name"
  end

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
    t.boolean  "uploaded_picture_to_s3", :default => false
    t.boolean  "attempted_geocode",      :default => false
    t.boolean  "attempted_s3_upload",    :default => false
    t.string   "category"
    t.boolean  "exclude",                :default => false
  end

  add_index "places", ["import_id"], :name => "idx_import_id"

  create_table "user_actions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "place_id"
    t.integer  "activity_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "type_id"
  end

  create_table "user_activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_pictures", :force => true do |t|
    t.string "picture_file_name"
    t.string "picture_content_type"
    t.string "picture_file_size"
    t.string "picture_updated_at"
  end

  create_table "user_place_activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "place_id"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.datetime "dob"
  end

end
