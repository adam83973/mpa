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

ActiveRecord::Schema.define(:version => 20150128184256) do

  create_table "activities", :force => true do |t|
    t.string   "title"
    t.text     "objective"
    t.string   "source"
    t.text     "content"
    t.text     "variations"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "image"
    t.text     "setup"
  end

  create_table "activities_courses", :id => false, :force => true do |t|
    t.integer "activity_id"
    t.integer "course_id"
  end

  create_table "activities_lessons", :id => false, :force => true do |t|
    t.integer "activity_id"
    t.integer "lesson_id"
  end

  create_table "activities_standards", :id => false, :force => true do |t|
    t.integer "activity_id"
    t.integer "standard_id"
  end

  create_table "appointments", :force => true do |t|
    t.integer  "locationId"
    t.integer  "location_id"
    t.integer  "reasonId"
    t.integer  "clientId"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.datetime "time"
    t.integer  "calendarId"
    t.integer  "visitMinutes"
    t.text     "note"
    t.string   "status"
    t.string   "hwHelpChild"
    t.string   "hwHelpClass"
    t.text     "hwHelpReason"
  end

  create_table "avatars", :force => true do |t|
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "badges", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "file"
    t.string   "file_name"
  end

  create_table "badges_students", :id => false, :force => true do |t|
    t.integer "badge_id"
    t.integer "student_id"
  end

  add_index "badges_students", ["badge_id", "student_id"], :name => "index_badges_students_on_badge_id_and_student_id"

  create_table "courses", :force => true do |t|
    t.string   "course_name"
    t.text     "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "grade"
    t.integer  "occupation_id"
    t.integer  "capacity"
  end

  create_table "courses_problems", :id => false, :force => true do |t|
    t.integer "problem_id"
    t.integer "course_id"
  end

  add_index "courses_problems", ["problem_id", "course_id"], :name => "index_courses_problems_on_problem_id_and_course_id"

  create_table "daily_location_reports", :force => true do |t|
    t.integer  "location_id"
    t.integer  "parent_logins"
    t.integer  "drop_count"
    t.integer  "add_count"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "total_enrollment"
  end

  create_table "enrollment_change_requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "admin_id"
    t.integer  "status",                        :default => 0
    t.date     "hold_start_date"
    t.date     "hold_return_date"
    t.date     "end_date"
    t.string   "reason_id"
    t.text     "other_reason"
    t.boolean  "restart_billing_authorization"
    t.integer  "student_id"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.integer  "type"
    t.text     "customer_experience"
    t.date     "possible_return_date"
    t.boolean  "submission_confirmation_email", :default => false
    t.boolean  "processed_confirmation_email",  :default => false
  end

  create_table "experience_points", :force => true do |t|
    t.integer  "experience_id"
    t.integer  "points"
    t.integer  "student_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "user_id"
    t.text     "comment"
    t.integer  "grade_id"
  end

  create_table "experiences", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.text     "content"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "points"
    t.string   "image"
    t.integer  "occupation_id"
    t.boolean  "active"
  end

  create_table "grades", :force => true do |t|
    t.integer  "student_id"
    t.integer  "lesson_id"
    t.integer  "score"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "comment"
    t.integer  "user_id"
    t.string   "grade_type"
  end

  create_table "issues", :force => true do |t|
    t.string   "name"
    t.text     "summary"
    t.integer  "user_id"
    t.integer  "priority"
    t.boolean  "resolved",   :default => false
    t.integer  "status",     :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "leads", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "email"
    t.integer  "user_id"
    t.integer  "stage_id"
    t.text     "student_information"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "source"
    t.boolean  "active",              :default => true
    t.date     "appointment_date"
    t.integer  "location_id"
  end

  create_table "lessons", :force => true do |t|
    t.string   "name"
    t.integer  "week"
    t.text     "assignment"
    t.text     "assignment_key"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.text     "assessment"
    t.text     "assessment_key"
    t.integer  "standard_id"
  end

  create_table "lessons_problems", :id => false, :force => true do |t|
    t.integer "lesson_id"
    t.integer "problem_id"
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

  create_table "notes", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "notable_id"
    t.string   "notable_type"
    t.boolean  "completed",      :default => false
    t.date     "action_date"
    t.integer  "location_id"
    t.integer  "opportunity_id"
    t.integer  "completed_by"
  end

  create_table "occupation_levels", :force => true do |t|
    t.integer  "level"
    t.integer  "points"
    t.text     "rewards"
    t.text     "privileges"
    t.text     "notes"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "occupation_id"
    t.integer  "bonus_credits", :default => 0
    t.string   "image"
  end

  create_table "occupations", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "offerings", :force => true do |t|
    t.integer  "course_id"
    t.integer  "location_id"
    t.string   "day"
    t.time     "time"
    t.string   "graduation_year"
    t.text     "comments"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "active"
    t.string   "classroom"
    t.boolean  "hidden",          :default => false
  end

  create_table "offerings_students", :id => false, :force => true do |t|
    t.integer "offering_id"
    t.integer "student_id"
  end

  add_index "offerings_students", ["student_id", "offering_id"], :name => "index_offerings_students_on_student_id_and_offering_id"

  create_table "offerings_users", :id => false, :force => true do |t|
    t.integer "offering_id"
    t.integer "user_id"
  end

  add_index "offerings_users", ["user_id", "offering_id"], :name => "index_offerings_users_on_user_id_and_offering_id"

  create_table "opportunities", :force => true do |t|
    t.integer  "registration_id"
    t.integer  "student_id"
    t.integer  "admin_id"
    t.integer  "offering_id"
    t.boolean  "attended_trial",        :default => false
    t.date     "trial_date"
    t.integer  "status",                :default => 0
    t.date     "possible_restart_date"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.date     "appointment_date"
    t.string   "parent_name"
    t.integer  "course_id"
    t.integer  "location_id"
    t.string   "student_name"
    t.date     "date_won"
    t.date     "date_lost"
    t.integer  "source"
    t.string   "title"
    t.string   "parent_email"
    t.string   "parent_phone"
    t.date     "undecided_date"
    t.integer  "user_id"
    t.integer  "interest_level",        :default => 0
    t.string   "other_source"
    t.boolean  "promotion_sent"
    t.integer  "promotion_id"
    t.boolean  "missed_trial",          :default => false
  end

  create_table "problems", :force => true do |t|
    t.string   "title"
    t.text     "desc"
    t.string   "strategies"
    t.string   "source"
    t.string   "answer"
    t.text     "methods"
    t.text     "variations"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "image"
    t.string   "activity_type"
    t.text     "setup"
  end

  create_table "problems_standards", :id => false, :force => true do |t|
    t.integer "problem_id"
    t.integer "standard_id"
  end

  create_table "problems_strategies", :id => false, :force => true do |t|
    t.integer "problem_id"
    t.integer "strategy_id"
  end

  add_index "problems_strategies", ["problem_id", "strategy_id"], :name => "index_problems_strategies_on_problem_id_and_strategy_id"

  create_table "registrations", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.date     "hold_date"
    t.date     "trial_date"
    t.boolean  "attended_first_class", :default => false
    t.boolean  "attended_trial",       :default => false
    t.integer  "student_id"
    t.integer  "offering_id"
    t.integer  "admin_id"
    t.integer  "status",               :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.date     "restart_date"
    t.integer  "subscription_id"
    t.integer  "hold_id"
    t.integer  "switch_id"
    t.boolean  "switch",               :default => false
    t.integer  "drop_reason"
  end

  create_table "resources", :force => true do |t|
    t.string   "resource"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "filename"
    t.string   "content_type"
    t.float    "file_size"
    t.string   "file"
    t.string   "category"
  end

  create_table "resourcings", :force => true do |t|
    t.integer  "resource_id"
    t.integer  "resourceable_id"
    t.string   "resourceable_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "stages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "standards", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "course_id"
  end

  create_table "strategies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "students", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birth_date"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "user_id"
    t.string   "rank"
    t.integer  "credits"
    t.integer  "xp_total"
    t.date     "restart_date"
    t.date     "return_date"
    t.date     "end_date"
    t.integer  "math_level",              :default => 0
    t.integer  "eng_level",               :default => 0
    t.integer  "prog_level",              :default => 0
    t.integer  "hold_status"
    t.date     "start_hold_date"
    t.integer  "mathematics_xp",          :default => 0
    t.integer  "engineering_xp",          :default => 0
    t.integer  "programmer_xp",           :default => 0
    t.string   "status"
    t.date     "start_date"
    t.boolean  "attended_first_class"
    t.integer  "avatar_id",               :default => 0
    t.string   "avatar_background_color", :default => "#ffffff"
  end

  create_table "time_punches", :force => true do |t|
    t.datetime "in"
    t.datetime "out"
    t.text     "comment"
    t.integer  "period"
    t.boolean  "modified"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "passion"
    t.string   "shirt_size"
    t.boolean  "has_key"
    t.boolean  "active",                               :default => true
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
    t.integer  "infusion_id"
    t.text     "last_payment"
    t.boolean  "active_subscription",                  :default => false
    t.integer  "subscription_count",                   :default => 0
    t.integer  "balance_due",                          :default => 0
    t.boolean  "year_end_campaign",                    :default => false
    t.integer  "check_appointments_id"
    t.integer  "default_location"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token", :unique => true
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.text     "url"
    t.integer  "lesson_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
