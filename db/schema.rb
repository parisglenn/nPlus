# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140904125904) do

  create_table "access_codes", :force => true do |t|
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type"
    t.string   "title"
    t.text     "body"
    t.string   "subject"
    t.integer  "user_id",          :default => 0, :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "deprecated_users_table", :force => true do |t|
    t.string   "full_name"
    t.string   "email"
    t.string   "password"
    t.integer  "office_id"
    t.integer  "team_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "deprecated_users_table", ["office_id"], :name => "index_users_on_office_id"
  add_index "deprecated_users_table", ["team_id"], :name => "index_users_on_team_id"

  create_table "event_tag_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "event_tags", :force => true do |t|
    t.integer  "event_id"
    t.integer  "interest_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "event_tags", ["event_id"], :name => "index_event_tags_on_event_id"
  add_index "event_tags", ["interest_id"], :name => "index_event_tags_on_interest_id"

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "location"
    t.date     "event_date",  :limit => 255
    t.integer  "geo_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.text     "description"
    t.time     "starts_at"
    t.time     "ends_at"
    t.integer  "rsvp_limit"
  end

  add_index "events", ["geo_id"], :name => "index_events_on_geo_id"

  create_table "feedbacks", :force => true do |t|
    t.text     "message"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "geos", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "parent_city"
    t.integer  "parent_region"
    t.integer  "parent_country"
    t.integer  "parent_zone"
    t.string   "location_type"
  end

  create_table "interests", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "office_hours", :force => true do |t|
    t.integer  "user_id"
    t.integer  "geo_id"
    t.string   "day_of_week"
    t.integer  "start_hour"
    t.integer  "start_minute"
    t.integer  "end_hour"
    t.integer  "end_minute"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "offices", :force => true do |t|
    t.string   "name"
    t.integer  "geo_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "offices", ["geo_id"], :name => "index_offices_on_geo_id"

  create_table "round_up_match_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "round_up_match_id"
    t.string   "rsvp"
    t.boolean  "open"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "round_up_matches", :force => true do |t|
    t.integer  "round_up_time_id"
    t.date     "date"
    t.string   "location"
    t.datetime "expires"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "geo_id"
  end

  create_table "round_up_rsvp_codes", :force => true do |t|
    t.string   "code"
    t.integer  "user_id"
    t.integer  "round_up_match_id"
    t.string   "action"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "round_up_times", :force => true do |t|
    t.string   "day"
    t.time     "start_hour"
    t.time     "end_hour"
    t.boolean  "deprecated"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "round_up_user_availabilities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "round_up_time_id"
    t.integer  "geo_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "rsvps", :force => true do |t|
    t.boolean  "host"
    t.string   "status"
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "rsvps", ["event_id"], :name => "index_rsvps_on_event_id"
  add_index "rsvps", ["user_id"], :name => "index_rsvps_on_user_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "geo_id"
    t.integer  "interest_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "subscribed"
  end

  add_index "subscriptions", ["geo_id"], :name => "index_subscriptions_on_geo_id"
  add_index "subscriptions", ["interest_id"], :name => "index_subscriptions_on_interest_id"
  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id"

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_geos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "geo_id"
    t.boolean  "subscribed"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_office_hours", :force => true do |t|
    t.integer  "user_id"
    t.integer  "geo_id"
    t.string   "day_of_week"
    t.time     "starts_at"
    t.time     "ends_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                           :default => "", :null => false
    t.string   "encrypted_password",              :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                   :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin"
    t.string   "event_notification_frequency"
    t.string   "round_up_notification_frequency"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "office_id"
    t.integer  "team_id"
    t.text     "description"
    t.string   "invite_code"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
