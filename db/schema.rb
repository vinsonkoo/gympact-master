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

ActiveRecord::Schema.define(version: 20160412012354) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "attachments", force: :cascade do |t|
    t.integer  "pact_id"
    t.string   "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goals", force: :cascade do |t|
    t.integer  "goal_days"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "pact_id"
    t.integer  "week_id"
  end

  add_index "goals", ["pact_id"], name: "index_pact_id_6"
  add_index "goals", ["user_id"], name: "index_user_id_5"
  add_index "goals", ["week_id"], name: "index_week_id_2"

  create_table "goals_pacts", id: false, force: :cascade do |t|
    t.integer "pact_id"
    t.integer "goal_id"
  end

  create_table "goals_weeks", id: false, force: :cascade do |t|
    t.integer "goal"
    t.integer "pact_id"
    t.integer "user_id"
    t.integer "week_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "pact_id"
    t.datetime "date_sent"
    t.boolean  "media"
    t.string   "image"
    t.string   "video"
    t.date     "date"
    t.string   "msg_date_time"
    t.string   "time"
    t.string   "sender"
    t.boolean  "is_workout"
    t.integer  "workout_id"
    t.integer  "week_id"
    t.string   "media_filename"
  end

  add_index "messages", ["pact_id"], name: "index_pact_id_4"
  add_index "messages", ["user_id"], name: "index_user_id"

  create_table "messages_workouts", id: false, force: :cascade do |t|
    t.integer "message_id"
    t.integer "workout_id"
  end

  create_table "pact_attachments", force: :cascade do |t|
    t.integer  "pact_id"
    t.string   "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pacts", force: :cascade do |t|
    t.string   "pact_name"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment"
  end

  add_index "pacts", ["pact_name"], name: "index_pacts_on_pact_name", unique: true

  create_table "pacts_penalties", id: false, force: :cascade do |t|
    t.integer "pact_id"
  end

  create_table "pacts_users", id: false, force: :cascade do |t|
    t.integer "pact_id"
    t.integer "user_id"
  end

  create_table "pacts_workouts", id: false, force: :cascade do |t|
    t.integer "pact_id"
    t.integer "workout_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "pact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "owed"
    t.float    "paid"
    t.integer  "week_id"
  end

  create_table "penalties", force: :cascade do |t|
    t.integer  "goal_days"
    t.float    "penalty"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pact_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "weeks", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "week_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pact_id"
  end

  add_index "weeks", ["pact_id", "week_number"], name: "index_weeks_on_pact_id_and_week_number", unique: true
  add_index "weeks", ["pact_id"], name: "index_pact_id_3"

  create_table "workout_types", force: :cascade do |t|
    t.string   "workout_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "workout_id"
  end

  add_index "workout_types", ["workout_id", "workout_type"], name: "index_workout_types_on_workout_id_and_workout_type", unique: true
  add_index "workout_types", ["workout_id"], name: "index_workout_id"

  create_table "workouts", force: :cascade do |t|
    t.float    "distance"
    t.string   "pace"
    t.string   "duration"
    t.string   "video1"
    t.string   "video2"
    t.string   "workout_name"
    t.text     "workout_description"
    t.boolean  "is_makeup_workout"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "week_id"
    t.datetime "sent"
    t.integer  "pact_id"
    t.integer  "message_id"
  end

  add_index "workouts", ["week_id"], name: "index_week_id"

end
