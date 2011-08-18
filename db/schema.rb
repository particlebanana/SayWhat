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

ActiveRecord::Schema.define(:version => 20110818161333) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["project_id"], :name => "index_comments_on_project_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "display_name"
    t.string   "city"
    t.string   "organization"
    t.text     "description"
    t.string   "permalink"
    t.string   "status"
    t.string   "esc_region",   :default => "pending"
    t.string   "dshs_region",  :default => "pending"
    t.string   "area",         :default => "pending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["name"], :name => "index_groups_on_name", :unique => true
  add_index "groups", ["permalink"], :name => "index_groups_on_permalink", :unique => true

  create_table "projects", :force => true do |t|
    t.integer  "group_id"
    t.string   "name"
    t.string   "display_name"
    t.string   "location"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "focus"
    t.string   "goal"
    t.text     "description"
    t.string   "audience"
    t.string   "involves"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["group_id"], :name => "index_projects_on_group_id"
  add_index "projects", ["name"], :name => "index_projects_on_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "role"
    t.string   "status"
    t.text     "bio"
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["group_id"], :name => "index_users_on_group_id"

end
