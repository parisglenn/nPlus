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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140115235329) do

  create_table "event_tags", force: true do |t|
    t.integer  "event_id"
    t.integer  "interest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_tags", ["event_id"], name: "index_event_tags_on_event_id"
  add_index "event_tags", ["interest_id"], name: "index_event_tags_on_interest_id"

  create_table "events", force: true do |t|
    t.string   "name"
    t.string   "start_time"
    t.string   "end_time"
    t.string   "location"
    t.string   "event_date"
    t.integer  "geo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["geo_id"], name: "index_events_on_geo_id"

  create_table "geos", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interests", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offices", force: true do |t|
    t.string   "name"
    t.integer  "geo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "geo_id"
    t.integer  "interest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["geo_id"], name: "index_subscriptions_on_geo_id"
  add_index "subscriptions", ["interest_id"], name: "index_subscriptions_on_interest_id"
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id"

  create_table "teams", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "full_name"
    t.string   "email"
    t.string   "password"
    t.integer  "office_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
