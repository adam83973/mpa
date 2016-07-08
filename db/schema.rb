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

ActiveRecord::Schema.define(version: 20160708003359) do

  create_table "activities", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "objective"
    t.string   "source",     limit: 255
    t.text     "content"
    t.text     "variations"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "image",      limit: 255
    t.text     "setup"
  end

  create_table "activities_courses", id: false, force: :cascade do |t|
    t.integer "activity_id"
    t.integer "course_id"
  end

  create_table "activities_lessons", id: false, force: :cascade do |t|
    t.integer "activity_id"
    t.integer "lesson_id"
  end

  create_table "activities_standards", id: false, force: :cascade do |t|
    t.integer "activity_id"
    t.integer "standard_id"
  end

  create_table "ahoy_messages", force: :cascade do |t|
    t.string   "token",      limit: 255
    t.text     "to"
    t.integer  "user_id"
    t.string   "user_type",  limit: 255
    t.string   "mailer",     limit: 255
    t.text     "subject"
    t.text     "content"
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "clicked_at"
  end

  add_index "ahoy_messages", ["token"], name: "index_ahoy_messages_on_token"
  add_index "ahoy_messages", ["user_id", "user_type"], name: "index_ahoy_messages_on_user_id_and_user_type"

  create_table "appointment_requests", force: :cascade do |t|
    t.text     "data"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "new_post",   default: false
  end

  create_table "appointments", force: :cascade do |t|
    t.integer  "locationId"
    t.integer  "location_id"
    t.integer  "reasonId"
    t.integer  "clientId"
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.datetime "time"
    t.integer  "calendarId"
    t.integer  "visitMinutes"
    t.text     "note"
    t.string   "status",       limit: 255
    t.string   "hwHelpChild",  limit: 255
    t.string   "hwHelpClass",  limit: 255
    t.text     "hwHelpReason"
  end

  create_table "assignments", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "score"
    t.boolean  "corrected",           default: false
    t.integer  "user_id"
    t.integer  "week"
    t.integer  "offering_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "comment"
    t.integer  "experience_point_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "experience_point_id"
    t.date     "date"
    t.integer  "offering_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "user_id"
    t.string   "integer"
  end

  create_table "avatars", force: :cascade do |t|
    t.string   "image",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "name",       limit: 255
  end

  create_table "badge_categories", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.boolean  "write_up_required",              default: false
    t.boolean  "multiple",                       default: false
    t.boolean  "parent_can_request",             default: true
  end

  create_table "badge_modules", force: :cascade do |t|
    t.string   "name",              limit: 255, default: "", null: false
    t.integer  "badge_category_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "badge_requests", force: :cascade do |t|
    t.integer  "badge_id"
    t.integer  "student_id"
    t.boolean  "parent_submission", default: false
    t.boolean  "approved",          default: false
    t.integer  "user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.date     "date_approved"
    t.text     "write_up"
  end

  create_table "badges", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "image",              limit: 255
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "file",               limit: 255
    t.string   "file_name",          limit: 255
    t.integer  "experience_id"
    t.text     "requirements"
    t.integer  "badge_category_id"
    t.boolean  "multiple",                       default: false
    t.integer  "submission_type"
    t.boolean  "write_up_required",              default: false
    t.boolean  "requires_approval",              default: false
    t.boolean  "parent_can_request",             default: true
    t.integer  "module_id"
    t.text     "script"
  end

  create_table "badges_students", id: false, force: :cascade do |t|
    t.integer "badge_id"
    t.integer "student_id"
  end

  add_index "badges_students", ["badge_id", "student_id"], name: "index_badges_students_on_badge_id_and_student_id"

  create_table "courses", force: :cascade do |t|
    t.string   "course_name",    limit: 255
    t.text     "description"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "grade",          limit: 255
    t.integer  "occupation_id"
    t.integer  "capacity"
    t.boolean  "specialization",             default: false
  end

  create_table "courses_problems", id: false, force: :cascade do |t|
    t.integer "problem_id"
    t.integer "course_id"
  end

  add_index "courses_problems", ["problem_id", "course_id"], name: "index_courses_problems_on_problem_id_and_course_id"

  create_table "daily_location_reports", force: :cascade do |t|
    t.integer  "location_id"
    t.integer  "parent_logins"
    t.integer  "drop_count"
    t.integer  "add_count"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "total_enrollment"
    t.integer  "hw_help_count",            default: 0
    t.integer  "assessment_count",         default: 0
    t.integer  "opportunities_won_count",  default: 0
    t.integer  "opportunities_lost_count", default: 0
    t.text     "offering_information"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "enrollment_change_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "admin_id"
    t.integer  "status",                                    default: 0
    t.date     "hold_start_date"
    t.date     "hold_return_date"
    t.date     "end_date"
    t.string   "reason_id",                     limit: 255
    t.text     "other_reason"
    t.boolean  "restart_billing_authorization"
    t.integer  "student_id"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.integer  "type"
    t.text     "customer_experience"
    t.date     "possible_return_date"
    t.boolean  "submission_confirmation_email",             default: false
    t.boolean  "processed_confirmation_email",              default: false
  end

  create_table "experience_points", force: :cascade do |t|
    t.integer  "experience_id"
    t.integer  "points"
    t.integer  "student_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "user_id"
    t.text     "comment"
    t.integer  "grade_id"
    t.boolean  "negative",      default: false
  end

  create_table "experiences", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "category",      limit: 255
    t.text     "content"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "points"
    t.string   "image",         limit: 255
    t.integer  "occupation_id"
    t.boolean  "active"
  end

  create_table "grades", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "lesson_id"
    t.integer  "score"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.text     "comment"
    t.integer  "user_id"
    t.string   "grade_type", limit: 255
  end

  create_table "help_session_records", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "user_id"
    t.date     "date"
    t.integer  "learning_plan_id"
    t.text     "comments"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "session_length",   default: 0
  end

  create_table "issues", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "summary"
    t.integer  "user_id"
    t.integer  "priority"
    t.boolean  "resolved",               default: false
    t.integer  "status",                 default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "leads", force: :cascade do |t|
    t.string   "first_name",          limit: 255
    t.string   "last_name",           limit: 255
    t.string   "phone",               limit: 255
    t.string   "email",               limit: 255
    t.integer  "user_id"
    t.integer  "stage_id"
    t.text     "student_information"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "source",              limit: 255
    t.boolean  "active",                          default: true
    t.date     "appointment_date"
    t.integer  "location_id"
  end

  create_table "learning_plan_goals", force: :cascade do |t|
    t.string   "name",                             null: false
    t.boolean  "completed",        default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "learning_plan_id"
  end

  create_table "learning_plan_issues", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "learning_plans", force: :cascade do |t|
    t.integer  "student_id"
    t.string   "grade"
    t.integer  "course_id"
    t.integer  "learning_plan_issue_id"
    t.text     "notes"
    t.text     "strengths"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "week"
    t.text     "assignment"
    t.text     "assignment_key"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "assessment"
    t.text     "assessment_key"
    t.integer  "standard_id"
  end

  create_table "lessons_problems", id: false, force: :cascade do |t|
    t.integer "lesson_id"
    t.integer "problem_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.string   "address",               limit: 255
    t.string   "city",                  limit: 255
    t.string   "state",                 limit: 255
    t.string   "zip",                   limit: 255
    t.boolean  "franchise"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "time",                  limit: 255
    t.text     "technical_information"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "recipient_id"
    t.boolean  "read",                     default: false
    t.boolean  "important",                default: false
    t.string   "subject",      limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "general"
    t.integer  "location_id"
    t.integer  "status",                   default: 0
    t.integer  "updated_by"
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "notable_id"
    t.string   "notable_type",   limit: 255
    t.boolean  "completed",                  default: false
    t.date     "action_date"
    t.integer  "location_id"
    t.integer  "opportunity_id"
    t.integer  "completed_by"
  end

  create_table "occupation_levels", force: :cascade do |t|
    t.integer  "level"
    t.integer  "points"
    t.text     "rewards"
    t.text     "privileges"
    t.text     "notes"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "occupation_id"
    t.integer  "bonus_credits",             default: 0
    t.string   "image",         limit: 255
  end

  create_table "occupations", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "offering_histories", force: :cascade do |t|
    t.integer  "offering_id"
    t.integer  "teacher_id"
    t.integer  "assistant_id"
    t.integer  "enrollment"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "course_id"
  end

  create_table "offerings", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "location_id"
    t.string   "day",             limit: 255
    t.time     "time"
    t.string   "graduation_year", limit: 255
    t.text     "comments"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.boolean  "active"
    t.string   "classroom",       limit: 255
    t.boolean  "hidden",                      default: false
    t.integer  "day_number"
  end

  create_table "offerings_students", id: false, force: :cascade do |t|
    t.integer "offering_id"
    t.integer "student_id"
  end

  add_index "offerings_students", ["student_id", "offering_id"], name: "index_offerings_students_on_student_id_and_offering_id"

  create_table "offerings_users", id: false, force: :cascade do |t|
    t.integer "offering_id"
    t.integer "user_id"
  end

  add_index "offerings_users", ["user_id", "offering_id"], name: "index_offerings_users_on_user_id_and_offering_id"

  create_table "opportunities", force: :cascade do |t|
    t.integer  "registration_id"
    t.integer  "student_id"
    t.integer  "admin_id"
    t.integer  "offering_id"
    t.boolean  "attended_trial",                    default: false
    t.date     "trial_date"
    t.integer  "status",                            default: 0
    t.date     "possible_restart_date"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.date     "appointment_date"
    t.string   "parent_name",           limit: 255
    t.integer  "course_id"
    t.integer  "location_id"
    t.string   "student_name",          limit: 255
    t.date     "date_won"
    t.date     "date_lost"
    t.integer  "source"
    t.string   "title",                 limit: 255
    t.string   "parent_email",          limit: 255
    t.string   "parent_phone",          limit: 255
    t.date     "undecided_date"
    t.integer  "user_id"
    t.integer  "interest_level",                    default: 0
    t.string   "other_source",          limit: 255
    t.boolean  "promotion_sent"
    t.integer  "promotion_id"
    t.boolean  "missed_trial",                      default: false
    t.boolean  "appointment_complete",              default: false
  end

  create_table "problems", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.text     "desc"
    t.string   "strategies",    limit: 255
    t.string   "source",        limit: 255
    t.string   "answer",        limit: 255
    t.text     "methods"
    t.text     "variations"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "image",         limit: 255
    t.string   "activity_type", limit: 255
    t.text     "setup"
  end

  create_table "problems_standards", id: false, force: :cascade do |t|
    t.integer "problem_id"
    t.integer "standard_id"
  end

  create_table "problems_strategies", id: false, force: :cascade do |t|
    t.integer "problem_id"
    t.integer "strategy_id"
  end

  add_index "problems_strategies", ["problem_id", "strategy_id"], name: "index_problems_strategies_on_problem_id_and_strategy_id"

  create_table "products", force: :cascade do |t|
    t.string   "name",                    null: false
    t.string   "sku"
    t.integer  "price",       default: 0
    t.integer  "credits",     default: 0
    t.integer  "quantity",    default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "location_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.date     "hold_date"
    t.date     "trial_date"
    t.boolean  "attended_first_class",      default: false
    t.boolean  "attended_trial",            default: false
    t.integer  "student_id"
    t.integer  "offering_id"
    t.integer  "admin_id"
    t.integer  "status",                    default: 0
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.date     "restart_date"
    t.integer  "subscription_id"
    t.integer  "hold_id"
    t.integer  "switch_id"
    t.boolean  "switch",                    default: false
    t.integer  "drop_reason"
    t.boolean  "payment_information_later", default: false
  end

  create_table "resources", force: :cascade do |t|
    t.string   "resource",     limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "filename",     limit: 255
    t.string   "content_type", limit: 255
    t.float    "file_size"
    t.string   "file",         limit: 255
    t.string   "category",     limit: 255
  end

  create_table "resourcings", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "resourceable_id"
    t.string   "resourceable_type", limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "stages", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "standards", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "category",    limit: 255
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "course_id"
  end

  create_table "strategies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "students", force: :cascade do |t|
    t.string   "first_name",              limit: 255
    t.string   "last_name",               limit: 255
    t.date     "birth_date"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.integer  "user_id"
    t.string   "rank",                    limit: 255
    t.integer  "credits"
    t.integer  "xp_total"
    t.date     "restart_date"
    t.date     "return_date"
    t.date     "end_date"
    t.integer  "math_level",                          default: 0
    t.integer  "eng_level",                           default: 0
    t.integer  "prog_level",                          default: 0
    t.integer  "hold_status"
    t.date     "start_hold_date"
    t.integer  "mathematics_xp",                      default: 0
    t.integer  "engineering_xp",                      default: 0
    t.integer  "programmer_xp",                       default: 0
    t.date     "start_date"
    t.boolean  "attended_first_class"
    t.integer  "avatar_id",                           default: 0
    t.string   "avatar_background_color", limit: 255, default: "#ffffff"
    t.boolean  "has_learning_plan",                   default: false
  end

  create_table "time_punches", force: :cascade do |t|
    t.datetime "in"
    t.datetime "out"
    t.text     "comment"
    t.integer  "period"
    t.boolean  "modified"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "access_token",  limit: 255
    t.string   "refresh_token", limit: 255
    t.datetime "expires_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "user_id",                      null: false
    t.integer  "student_id"
    t.integer  "credits_redeemed"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "product_id"
    t.integer  "location_id"
    t.integer  "process"
    t.integer  "quantity",         default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",              limit: 255
    t.string   "last_name",               limit: 255
    t.string   "phone",                   limit: 255
    t.string   "passion",                 limit: 255
    t.string   "shirt_size",              limit: 255
    t.boolean  "has_key"
    t.boolean  "active",                              default: true
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "location_id"
    t.string   "email",                   limit: 255, default: "",    null: false
    t.string   "encrypted_password",      limit: 255, default: ""
    t.string   "reset_password_token",    limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",      limit: 255
    t.string   "last_sign_in_ip",         limit: 255
    t.boolean  "admin",                               default: false
    t.string   "role",                    limit: 255
    t.string   "invitation_token",        limit: 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type",         limit: 255
    t.integer  "infusion_id"
    t.text     "last_payment"
    t.boolean  "active_subscription",                 default: false
    t.integer  "subscription_count",                  default: 0
    t.integer  "balance_due",                         default: 0
    t.boolean  "year_end_campaign",                   default: false
    t.integer  "check_appointments_id"
    t.integer  "default_location"
    t.boolean  "appointment_rescheduled",             default: false
    t.boolean  "confirmation_opt_out",                default: false
    t.text     "billing_note",                        default: ""
    t.boolean  "hide_badge_banner",                   default: false
    t.boolean  "termination_sequence",                default: false
    t.boolean  "first_email_reminder",                default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      limit: 255,        null: false
    t.integer  "item_id",                           null: false
    t.string   "event",          limit: 255,        null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object",         limit: 1073741823
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

  create_table "videos", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "url"
    t.integer  "lesson_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
