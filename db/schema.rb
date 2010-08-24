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

ActiveRecord::Schema.define(:version => 20100824132246) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.string   "icon_file_size"
    t.string   "icon_updated_at"
    t.string   "activity_group_name"
    t.string   "category"
    t.integer  "activity_category_id"
    t.integer  "create_user_id"
    t.integer  "admin_user_id"
    t.string   "auth_code"
    t.integer  "fb_page_id",           :limit => 8
    t.string   "url"
    t.string   "fb_page_url"
    t.string   "website"
    t.integer  "people_count",                      :default => 0
    t.integer  "place_count",                       :default => 0
  end

  create_table "activity_categories", :force => true do |t|
    t.string "description"
  end

  create_table "attendees", :force => true do |t|
    t.integer  "event_id"
    t.string   "user_id"
    t.integer  "attendee_type"
    t.integer  "attendee_response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tickets"
    t.string   "ticket_ref"
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

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.string   "comment_text"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "place_id"
    t.datetime "when_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "duration"
    t.string   "title"
    t.boolean  "allDay"
    t.datetime "start"
    t.datetime "end"
    t.string   "url"
    t.integer  "place_activity_id"
    t.string   "description"
    t.integer  "tickets_dispensed"
    t.integer  "tickets_bought"
    t.float    "ticket_price"
  end

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "place_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "good_for"
  end

  create_table "fb_degree", :id => false, :force => true do |t|
    t.integer "fb_user_id1", :limit => 8
    t.integer "fb_user_id2", :limit => 8
  end

  create_table "fb_events_aggregate", :id => false, :force => true do |t|
    t.integer "count",       :limit => 8, :default => 0, :null => false
    t.integer "fb_user_id1"
    t.integer "fb_user_id2"
  end

  create_table "fb_friends", :force => true do |t|
    t.integer "fb_user_id1", :limit => 8
    t.integer "fb_user_id2", :limit => 8
    t.boolean "is_friend"
  end

  create_table "fb_friends2", :id => false, :force => true do |t|
    t.integer "id",                       :default => 0, :null => false
    t.integer "fb_user_id1", :limit => 8
    t.integer "fb_user_id2", :limit => 8
    t.boolean "is_friend"
  end

  create_table "fb_likes_aggregate", :id => false, :force => true do |t|
    t.integer "fb_user_id1", :limit => 8
    t.integer "fb_user_id2", :limit => 8
    t.string  "category"
    t.integer "count",       :limit => 8, :default => 0, :null => false
  end

  add_index "fb_likes_aggregate", ["fb_user_id1"], :name => "u3"
  add_index "fb_likes_aggregate", ["fb_user_id2"], :name => "u4"

  create_table "fb_report_aggregate", :id => false, :force => true do |t|
    t.integer "user1_ud",           :limit => 8
    t.string  "user1_name"
    t.string  "user1_gender"
    t.string  "user1_relationship"
    t.integer "user2_id",           :limit => 8
    t.string  "user2_name"
    t.string  "user2_gender"
    t.string  "user2_relationship"
    t.integer "events",                          :default => 0, :null => false
    t.integer "events_by_location",              :default => 0, :null => false
    t.integer "music",                           :default => 0, :null => false
    t.integer "business",                        :default => 0, :null => false
    t.integer "store",                           :default => 0, :null => false
    t.integer "film",                            :default => 0, :null => false
    t.integer "nonprofit",                       :default => 0, :null => false
    t.integer "fashion",                         :default => 0, :null => false
    t.integer "sport",                           :default => 0, :null => false
    t.integer "writer",                          :default => 0, :null => false
    t.integer "artist",                          :default => 0, :null => false
    t.integer "is_friend",                       :default => 0, :null => false
    t.integer "one_degree",                      :default => 0, :null => false
  end

  add_index "fb_report_aggregate", ["user1_ud"], :name => "u1"
  add_index "fb_report_aggregate", ["user2_id"], :name => "u2"

  create_table "fb_user_events", :force => true do |t|
    t.integer  "fb_user_id"
    t.string   "user_name"
    t.integer  "event_id",       :limit => 8
    t.string   "event_location"
    t.string   "event_name"
    t.datetime "event_start"
    t.datetime "event_end"
    t.datetime "date_added"
    t.datetime "date_updated"
    t.string   "rsvp_status"
    t.string   "city"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "state"
    t.string   "street"
    t.string   "event_type"
    t.string   "event_subtype"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  add_index "fb_user_events", ["event_id"], :name => "fb_user_events_event_id"
  add_index "fb_user_events", ["event_location"], :name => "fb_user_events_event_location"
  add_index "fb_user_events", ["fb_user_id"], :name => "fb_user_events_fb_user_id"

  create_table "fb_user_events1", :id => false, :force => true do |t|
    t.integer  "id",                          :default => 0, :null => false
    t.integer  "fb_user_id"
    t.string   "user_name"
    t.integer  "event_id",       :limit => 8
    t.string   "event_location"
    t.string   "event_name"
    t.datetime "event_start"
    t.datetime "event_end"
    t.datetime "date_added"
    t.datetime "date_updated"
  end

  create_table "fb_user_likes", :force => true do |t|
    t.integer "fb_user_id"
    t.string  "category"
    t.integer "like_id",    :limit => 8
    t.string  "like_name"
  end

  add_index "fb_user_likes", ["category"], :name => "fb_user_likes_category"
  add_index "fb_user_likes", ["fb_user_id"], :name => "fb_user_likes_fb_user_id"
  add_index "fb_user_likes", ["like_name"], :name => "fb_user_likes_name"

  create_table "fb_user_likes1", :id => false, :force => true do |t|
    t.integer "id",                      :default => 0, :null => false
    t.integer "fb_user_id"
    t.string  "category"
    t.integer "like_id",    :limit => 8
    t.string  "like_name"
  end

  create_table "fb_user_matches_events", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.string  "fb_user_name1"
    t.integer "fb_user_source_id1", :limit => 8
    t.integer "fb_user_id2"
    t.string  "fb_user_name2"
    t.integer "fb_user_source_id2", :limit => 8
    t.string  "event_name1"
    t.string  "event_name2"
    t.string  "event_location"
  end

  create_table "fb_user_matches_likes", :id => false, :force => true do |t|
    t.integer "like_id1",                 :default => 0, :null => false
    t.integer "fb_user_id1", :limit => 8
    t.integer "like_id2",                 :default => 0, :null => false
    t.integer "fb_user_id2", :limit => 8
    t.string  "category"
    t.string  "like_name"
  end

  create_table "fb_users", :force => true do |t|
    t.integer  "fb_user_id",        :limit => 8
    t.string   "name"
    t.string   "gender"
    t.string   "relationship"
    t.string   "birthday"
    t.integer  "location_id",       :limit => 8
    t.datetime "date_added"
    t.datetime "date_updated"
    t.integer  "fb_user_source_id", :limit => 8
    t.string   "first_name"
    t.string   "religion"
    t.string   "meeting_for"
    t.string   "meeting_sex"
    t.string   "cl_country"
    t.string   "cl_city"
    t.string   "cl_state"
    t.integer  "cl_id",             :limit => 8
    t.string   "cl_zip"
    t.string   "htl_country"
    t.string   "htl_city"
    t.string   "htl_state"
    t.integer  "htl_id",            :limit => 8
    t.string   "htl_zip"
  end

  add_index "fb_users", ["fb_user_source_id"], :name => "idx_source"
  add_index "fb_users", ["gender"], :name => "idx_fb_users_gender"
  add_index "fb_users", ["name"], :name => "idx_fb_users_name"
  add_index "fb_users", ["relationship"], :name => "idx_fb_users_relationship"

  create_table "fb_users1", :id => false, :force => true do |t|
    t.integer  "id",                             :default => 0, :null => false
    t.integer  "fb_user_id",        :limit => 8
    t.string   "name"
    t.string   "gender"
    t.string   "relationship"
    t.string   "birthday"
    t.integer  "location_id",       :limit => 8
    t.datetime "date_added"
    t.datetime "date_updated"
    t.integer  "fb_user_source_id", :limit => 8
  end

  create_table "invitations", :force => true do |t|
    t.string   "email"
    t.datetime "sent_at"
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ldc", :id => false, :force => true do |t|
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
    t.integer "id"
  end

  add_index "ldc", ["id"], :name => "idx_ldc_id"

  create_table "like_weighting", :force => true do |t|
    t.string  "category"
    t.integer "number_of_likes"
    t.integer "weighting"
  end

  create_table "locations", :force => true do |t|
    t.string "name"
  end

  create_table "mailer_messages", :force => true do |t|
    t.integer  "user_id"
    t.string   "type"
    t.string   "mail_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "message_type",            :default => 0
    t.integer  "thread_original_mail_id"
  end

  create_table "pages", :force => true do |t|
    t.integer  "page_id",          :limit => 8
    t.string   "access_token"
    t.integer  "administrator_id", :limit => 8
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "place_activities", :force => true do |t|
    t.integer "activity_id"
    t.integer "place_id"
    t.string  "url"
  end

  create_table "place_activity_events", :force => true do |t|
    t.integer  "place_activity_id", :limit => 8
    t.string   "image_file"
    t.string   "header"
    t.string   "description",       :limit => 1000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "info_html",         :limit => 1000
  end

  create_table "place_categories", :force => true do |t|
    t.string "description"
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
    t.boolean  "uploaded_picture_to_s3",              :default => false
    t.boolean  "attempted_geocode",                   :default => false
    t.boolean  "attempted_s3_upload",                 :default => false
    t.string   "category"
    t.boolean  "exclude",                             :default => false
    t.integer  "place_category_id"
    t.integer  "create_user_id"
    t.integer  "admin_user_id"
    t.string   "auth_code"
    t.integer  "fb_page_id",             :limit => 8
    t.string   "url"
    t.string   "fb_page_url"
    t.integer  "people_count",                        :default => 0
    t.integer  "activity_count",                      :default => 0
  end

  add_index "places", ["import_id"], :name => "idx_import_id"
  add_index "places", ["name"], :name => "index_places_on_name"

  create_table "relation_events_all", :id => false, :force => true do |t|
    t.integer "user_id",        :limit => 8
    t.integer "user_source_id", :limit => 8
    t.string  "user_name",      :limit => 200
    t.integer "user_gender",    :limit => 1
    t.integer "user_rel",       :limit => 2
    t.integer "event_id",       :limit => 8
    t.string  "event_name",     :limit => 200
    t.float   "event_weight"
    t.string  "event_category", :limit => 200
    t.string  "event_location", :limit => 500
  end

  add_index "relation_events_all", ["event_id"], :name => "idx_relation_events_all_id"
  add_index "relation_events_all", ["event_location"], :name => "idx_relation_events_all_location"
  add_index "relation_events_all", ["event_name"], :name => "idx_relation_events_all_event_name"
  add_index "relation_events_all", ["user_id"], :name => "idx_relation_events_all_user_id"
  add_index "relation_events_all", ["user_source_id"], :name => "idx_relation_events_all_source_user_id"

  create_table "relation_likes", :id => false, :force => true do |t|
    t.integer "user_id",        :limit => 8
    t.integer "user_source_id", :limit => 8
    t.string  "user_name",      :limit => 200
    t.integer "user_gender",    :limit => 1
    t.integer "user_rel",       :limit => 2
    t.integer "like_id",        :limit => 8
    t.string  "like_name",      :limit => 200
    t.float   "like_weight"
    t.string  "like_category",  :limit => 200
  end

  add_index "relation_likes", ["like_id"], :name => "idx_relation_like_id"
  add_index "relation_likes", ["user_id"], :name => "idx_relation_likes_user_id"
  add_index "relation_likes", ["user_source_id"], :name => "idx_relation_source_user_id"

  create_table "relation_rel", :id => false, :force => true do |t|
    t.integer "user_id1",        :limit => 8
    t.integer "user_source_id1", :limit => 8
    t.string  "user_name1",      :limit => 200
    t.integer "user_id2",        :limit => 8
    t.integer "user_source_id2", :limit => 8
    t.string  "user_name2",      :limit => 200
    t.integer "object_id",       :limit => 8
    t.string  "object_name",     :limit => 200
    t.string  "object_type",     :limit => 500
    t.float   "object_weight"
  end

  add_index "relation_rel", ["object_id"], :name => "idx_relation_rel_like_id"
  add_index "relation_rel", ["user_id1"], :name => "idx_relation_rel_user_id1"
  add_index "relation_rel", ["user_id2"], :name => "idx_relation_rel_user_id2"
  add_index "relation_rel", ["user_source_id1"], :name => "idx_relation_rel_user_source_id1"
  add_index "relation_rel", ["user_source_id2"], :name => "idx_relation_rel_user_source_id2"

  create_table "relation_summary", :id => false, :force => true do |t|
    t.integer "user_id1",        :limit => 8
    t.integer "user_source_id1", :limit => 8
    t.string  "user_name1",      :limit => 200
    t.integer "user_id2",        :limit => 8
    t.integer "user_source_id2", :limit => 8
    t.string  "user_name2",      :limit => 200
    t.integer "common_count"
    t.float   "weight"
  end

  create_table "relation_users", :id => false, :force => true do |t|
    t.integer "user_id",      :limit => 8
    t.string  "name",         :limit => 200
    t.string  "gender",       :limit => 50
    t.string  "relationship", :limit => 200
    t.integer "source_id",    :limit => 8
  end

  add_index "relation_users", ["source_id"], :name => "idx_relation_users_user_source_id"
  add_index "relation_users", ["user_id"], :name => "idx_relation_users_user_id"

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "event_id",      :limit => 8
    t.integer  "user_id"
    t.string   "pp_ref"
    t.string   "quantity"
    t.float    "price"
    t.integer  "ticket_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timeline_events", :force => true do |t|
    t.string   "event_type"
    t.string   "subject_type"
    t.string   "actor_type"
    t.string   "secondary_subject_type"
    t.integer  "subject_id"
    t.integer  "actor_id"
    t.integer  "secondary_subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_favorites", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "friend_id"
  end

  create_table "user_pictures", :force => true do |t|
    t.string "picture_file_name"
    t.string "picture_content_type"
    t.string "picture_file_size"
    t.string "picture_updated_at"
  end

  create_table "user_place_activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
    t.string   "description"
    t.integer  "place_activity_id"
    t.integer  "time_of_day"
    t.integer  "day_of_week"
  end

  create_table "user_places", :force => true do |t|
    t.integer  "user_id"
    t.integer  "place_id"
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
    t.string   "postcode"
    t.float    "lat"
    t.float    "long"
    t.integer  "status",                                  :default => 1
    t.integer  "c",                                       :default => 1
    t.integer  "height",                                  :default => 0
    t.integer  "body_type",                               :default => 0
    t.integer  "fb_user_id",                :limit => 8
    t.string   "email_hash"
    t.string   "fb_session_key"
    t.integer  "partner_type"
    t.boolean  "note_matches",                            :default => true
    t.boolean  "note_tips",                               :default => true
    t.boolean  "note_messages",                           :default => true
    t.datetime "mail_matches"
    t.datetime "mail_activities"
    t.datetime "mail_photos"
    t.string   "partner_website"
    t.string   "facebook_page"
    t.string   "access_token"
    t.boolean  "fb_pull",                                 :default => false
  end

  create_table "vactivities_count", :id => false, :force => true do |t|
    t.integer "id",                 :default => 0, :null => false
    t.integer "count", :limit => 8, :default => 0, :null => false
  end

  create_table "vcommon", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.string  "fb_user_name1"
    t.integer "fb_user_source_id1", :limit => 8
    t.integer "fb_user_id2"
    t.string  "fb_user_name2"
    t.integer "fb_user_source_id2", :limit => 8
    t.decimal "sum(weight)",                      :precision => 65, :scale => 4
    t.integer "sum(cnt)",           :limit => 41, :precision => 41, :scale => 0
  end

  create_table "vcommon_event", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.integer "fb_user_source_id1", :limit => 8
    t.string  "fb_user_name1"
    t.integer "fb_user_id2"
    t.integer "fb_user_source_id2", :limit => 8
    t.string  "fb_user_name2"
    t.string  "event_location1"
    t.string  "event_location2"
    t.decimal "weight",                          :precision => 11, :scale => 1, :default => 0.0, :null => false
    t.integer "cnt",                                                            :default => 0,   :null => false
  end

  create_table "vcommon_events", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.integer "fb_user_source_id1", :limit => 8
    t.string  "fb_user_name1"
    t.integer "fb_user_id2"
    t.integer "fb_user_source_id2", :limit => 8
    t.string  "fb_user_name2"
    t.string  "event_location1"
    t.string  "event_location2"
  end

  create_table "vcommon_events_evt", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.integer "fb_user_source_id1", :limit => 8
    t.string  "fb_user_name1"
    t.integer "fb_user_id2"
    t.integer "fb_user_source_id2", :limit => 8
    t.string  "fb_user_name2"
    t.string  "event_location1"
    t.string  "event_location2"
    t.integer "weight",                          :default => 0, :null => false
    t.integer "cnt",                             :default => 0, :null => false
  end

  create_table "vcommon_events_loc", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.integer "fb_user_source_id1", :limit => 8
    t.string  "fb_user_name1"
    t.integer "fb_user_id2"
    t.integer "fb_user_source_id2", :limit => 8
    t.string  "fb_user_name2"
    t.string  "event_location1"
    t.string  "event_location2"
    t.decimal "weight",                          :precision => 2, :scale => 1, :default => 0.0, :null => false
    t.integer "cnt",                                                           :default => 0,   :null => false
  end

  create_table "vcommon_likes", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.string  "fb_user_name1"
    t.integer "fb_user_source_id1", :limit => 8
    t.integer "fb_user_id2"
    t.string  "fb_user_name2"
    t.integer "fb_user_source_id2", :limit => 8
    t.string  "like_name"
    t.string  "category"
    t.integer "like_id",            :limit => 8
  end

  create_table "vcommon_union", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.string  "fb_user_name1"
    t.integer "fb_user_source_id1", :limit => 8
    t.integer "fb_user_id2"
    t.string  "fb_user_name2"
    t.integer "fb_user_source_id2", :limit => 8
    t.decimal "weight",                          :precision => 58, :scale => 4
    t.integer "cnt",                :limit => 8,                                :default => 0, :null => false
  end

  create_table "vevents", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.string  "fb_user_name1"
    t.integer "fb_user_source_id1", :limit => 8
    t.integer "fb_user_id2"
    t.string  "fb_user_name2"
    t.integer "fb_user_source_id2", :limit => 8
    t.decimal "weight",                          :precision => 33, :scale => 1
    t.integer "cnt",                :limit => 8,                                :default => 0, :null => false
  end

  create_table "vevents_event", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.integer "fb_user_id2"
    t.string  "object_type",   :limit => 9, :default => "", :null => false
    t.integer "object_id",     :limit => 8
    t.string  "object_name"
    t.string  "object_detail", :limit => 0, :default => "", :null => false
    t.integer "weight",                     :default => 0,  :null => false
    t.integer "cnt",                        :default => 0,  :null => false
  end

  create_table "vevents_location", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.integer "fb_user_id2"
    t.string  "object_type",   :limit => 9,                               :default => "",  :null => false
    t.binary  "object_id",     :limit => 0
    t.string  "object_name"
    t.string  "object_detail", :limit => 0,                               :default => "",  :null => false
    t.decimal "weight",                     :precision => 2, :scale => 1, :default => 0.0, :null => false
    t.integer "cnt",                                                      :default => 0,   :null => false
  end

  create_table "visitors", :force => true do |t|
    t.integer  "fb_user_id",   :limit => 8
    t.string   "access_token"
    t.string   "auth_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "admin"
  end

  create_table "vlike_points", :id => false, :force => true do |t|
    t.string  "like_name"
    t.string  "category"
    t.integer "like_id",                              :limit => 8
    t.integer "count(*)",                             :limit => 8,                                :default => 0, :null => false
    t.decimal "points",                                            :precision => 25, :scale => 4
    t.decimal "((1 - (count(0) / 1500)) - 0.887)*10",              :precision => 28, :scale => 4
    t.decimal "weighting/10",                                      :precision => 14, :scale => 4
    t.decimal "weight",                                            :precision => 36, :scale => 4
  end

  create_table "vlikes", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.string  "fb_user_name1"
    t.integer "fb_user_source_id1", :limit => 8
    t.integer "fb_user_id2"
    t.string  "fb_user_name2"
    t.integer "fb_user_source_id2", :limit => 8
    t.decimal "weight",                          :precision => 58, :scale => 4
    t.integer "cnt",                :limit => 8,                                :default => 0, :null => false
  end

  create_table "vlikes_raw", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.integer "fb_user_id2"
    t.string  "object_type"
    t.integer "object_id",     :limit => 8
    t.string  "object_name"
    t.string  "object_detail", :limit => 0, :default => "", :null => false
  end

  create_table "vlikes_weighted", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.integer "fb_user_id2"
    t.string  "object_type"
    t.integer "object_id",     :limit => 8
    t.string  "object_name"
    t.string  "object_detail", :limit => 0,                                :default => "", :null => false
    t.decimal "weight",                     :precision => 36, :scale => 4
    t.integer "cnt",                                                       :default => 0,  :null => false
  end

  create_table "vmatcher", :id => false, :force => true do |t|
    t.integer "U1",              :default => 0, :null => false
    t.integer "U2",              :default => 0, :null => false
    t.integer "C",  :limit => 8
    t.integer "A",  :limit => 8
    t.integer "P",  :limit => 8
  end

  create_table "vmatches", :id => false, :force => true do |t|
    t.integer "U1"
    t.integer "U2"
    t.integer "C",  :limit => 8, :default => 0, :null => false
    t.integer "A",  :limit => 8
    t.integer "P",  :limit => 8
  end

  create_table "vmatches_all", :id => false, :force => true do |t|
    t.integer "U1", :default => 0, :null => false
    t.integer "U2", :default => 0, :null => false
  end

  create_table "vplaces_count", :id => false, :force => true do |t|
    t.integer "id",                 :default => 0, :null => false
    t.integer "count", :limit => 8, :default => 0, :null => false
  end

  create_table "vrelationships", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.string  "fb_user_name1"
    t.integer "fb_user_id2"
    t.string  "fb_user_name2"
    t.integer "one_degree"
    t.boolean "is_friend"
    t.decimal "weight_sum",                  :precision => 58, :scale => 4
    t.integer "count_sum",     :limit => 32, :precision => 32, :scale => 0
    t.string  "object_type"
    t.integer "object_id",     :limit => 8
    t.string  "object_name"
    t.string  "object_detail", :limit => 0,                                 :default => "", :null => false
    t.decimal "weight",                      :precision => 36, :scale => 4
    t.integer "cnt",                                                        :default => 0,  :null => false
  end

  create_table "vrelationships_agg", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.string  "fb_user_name1"
    t.integer "fb_user_id2"
    t.string  "fb_user_name2"
    t.integer "one_degree"
    t.boolean "is_friend"
    t.decimal "weight_sum",                  :precision => 58, :scale => 4
    t.integer "count_sum",     :limit => 32, :precision => 32, :scale => 0
  end

  create_table "vrelationships_raw", :id => false, :force => true do |t|
    t.integer "fb_user_id1"
    t.integer "fb_user_id2"
    t.string  "object_type"
    t.integer "object_id",     :limit => 8
    t.string  "object_name"
    t.string  "object_detail", :limit => 0,                                :default => "", :null => false
    t.decimal "weight",                     :precision => 36, :scale => 4
    t.integer "cnt",                                                       :default => 0,  :null => false
  end

  create_table "vuser_activities", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "activity_id"
  end

  create_table "vuser_activities_match", :id => false, :force => true do |t|
    t.integer "U1",                          :default => 0, :null => false
    t.integer "U2",                          :default => 0, :null => false
    t.integer "activity_count", :limit => 8, :default => 0, :null => false
  end

  create_table "vuser_places", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "place_id"
  end

  create_table "vuser_places_match", :id => false, :force => true do |t|
    t.integer "U1"
    t.integer "U2"
    t.integer "place_count", :limit => 8, :default => 0, :null => false
  end

end
