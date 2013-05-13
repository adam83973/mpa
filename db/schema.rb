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

ActiveRecord::Schema.define(:version => 20130513184209) do

  create_table "courses", :force => true do |t|
    t.string   "course_name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "experience_points", :force => true do |t|
    t.integer  "experience_id"
    t.integer  "points"
    t.integer  "student_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "user_id"
    t.text     "comment"
  end

  create_table "experiences", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "grades", :force => true do |t|
    t.integer  "student_id"
    t.integer  "course_id"
    t.integer  "lesson_id"
    t.boolean  "assessment"
    t.integer  "score"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lessons", :force => true do |t|
    t.string   "name"
    t.integer  "week"
    t.integer  "course_id"
    t.text     "assignment"
    t.text     "assignment_key"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.text     "assessment"
    t.text     "assessment_key"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.boolean  "franchise"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "time"
  end

  create_table "offerings", :force => true do |t|
    t.integer  "course_id"
    t.integer  "location_id"
    t.string   "day"
    t.time     "time"
    t.integer  "user_id"
    t.string   "graduation_year"
    t.text     "comments"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.boolean  "active"
  end

  create_table "offerings_students", :id => false, :force => true do |t|
    t.integer "offering_id"
    t.integer "student_id"
  end

  add_index "offerings_students", ["student_id", "offering_id"], :name => "index_offerings_students_on_student_id_and_offering_id"

  create_table "students", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birth_date"
    t.date     "start_date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.string   "rank"
    t.integer  "credits"
    t.integer  "xp_total"
    t.boolean  "active"
  end

  create_table "time_punches", :force => true do |t|
    t.datetime "in"
    t.datetime "out"
    t.string   "comment"
    t.boolean  "modified",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "passion"
    t.string   "shirt_size"
    t.boolean  "has_key"
    t.string   "address"
    t.boolean  "active"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.integer  "location_id"
    t.string   "email",                                :default => "",    :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin",                                :default => false
    t.string   "role"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token", :unique => true
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
