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

ActiveRecord::Schema.define(:version => 20130304014750) do

  create_table "courses", :force => true do |t|
    t.string   "course_name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
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
    t.text     "assesment"
    t.text     "assesment_key"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
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
  end

  create_table "students", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birth_date"
    t.date     "start_date"
    t.integer  "offering_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "roll"
    t.string   "phone"
    t.string   "passion"
    t.string   "shirt_size"
    t.boolean  "has_key"
    t.string   "address"
    t.boolean  "admin"
    t.boolean  "active"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "location_id"
  end

end
