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

ActiveRecord::Schema.define(version: 20150117101441) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.boolean  "active"
    t.datetime "is_from_date"
    t.datetime "is_to_date"
    t.integer  "default_slot_duration"
    t.integer  "changed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "teacher_reg_from_date"
    t.datetime "teacher_reg_to_date"
    t.datetime "student_reg_from_date"
    t.datetime "student_reg_to_date"
  end

  create_table "reservations", force: true do |t|
    t.integer  "changed_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id",   null: false
    t.integer  "teacher_id", null: false
    t.integer  "slot_id",    null: false
    t.integer  "student_id"
  end

  add_index "reservations", ["event_id"], name: "index_reservations_on_event_id", using: :btree
  add_index "reservations", ["slot_id"], name: "index_reservations_on_slot_id", using: :btree
  add_index "reservations", ["student_id"], name: "index_reservations_on_student_id", using: :btree
  add_index "reservations", ["teacher_id"], name: "index_reservations_on_teacher_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "slots", force: true do |t|
    t.datetime "slot_date"
    t.datetime "from_time"
    t.datetime "to_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id",   null: false
  end

  create_table "students", force: true do |t|
    t.string   "name"
    t.string   "firstname"
    t.string   "code"
    t.string   "email"
    t.integer  "changed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id",    null: false
    t.integer  "event_id",   null: false
  end

  create_table "teachers", force: true do |t|
    t.string   "name"
    t.string   "firstname"
    t.string   "abbreviation"
    t.string   "code"
    t.string   "email"
    t.integer  "changed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id",     null: false
    t.integer  "team_id"
    t.string   "room_title"
  end

  create_table "teacherteams", force: true do |t|
    t.integer  "changed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id",   null: false
    t.integer  "teacher_id", null: false
    t.integer  "team_id",    null: false
  end

  add_index "teacherteams", ["event_id"], name: "index_teacherteams_on_event_id", using: :btree
  add_index "teacherteams", ["teacher_id"], name: "index_teacherteams_on_teacher_id", using: :btree
  add_index "teacherteams", ["team_id"], name: "index_teacherteams_on_team_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "changed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id",    null: false
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password"
    t.boolean  "active"
    t.integer  "role_type"
    t.string   "address"
    t.string   "string"
    t.string   "place"
    t.string   "zip"
    t.integer  "sex"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "firstname"
    t.integer  "changed_id"
    t.string   "country"
    t.string   "mobile"
    t.datetime "last_login_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
