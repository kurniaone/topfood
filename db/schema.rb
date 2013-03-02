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

ActiveRecord::Schema.define(:version => 20130302064151) do

  create_table "access_settings", :force => true do |t|
    t.string   "order_class"
    t.integer  "position_id"
    t.datetime "deleted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "approval_roles", :force => true do |t|
    t.integer  "approval_setting_id"
    t.integer  "role_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "approval_settings", :force => true do |t|
    t.boolean  "center"
    t.string   "order_class"
    t.datetime "deleted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "approvals", :force => true do |t|
    t.integer  "order_id"
    t.integer  "user_id"
    t.string   "user_name"
    t.integer  "role_id"
    t.string   "role_name"
    t.boolean  "approved"
    t.datetime "do_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "reason"
  end

  create_table "apps_orders", :force => true do |t|
    t.string   "app_id"
    t.integer  "order_id"
    t.datetime "order_timestamp"
    t.datetime "app_timestamp"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "branches", :force => true do |t|
    t.boolean  "center"
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "profile"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "departments", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.datetime "deleted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "employee_details", :force => true do |t|
    t.integer  "order_id"
    t.integer  "position_id"
    t.integer  "department_id"
    t.text     "description"
    t.integer  "quantity"
    t.string   "gender"
    t.date     "used_date"
    t.datetime "deleted_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "order_details", :force => true do |t|
    t.integer  "order_id"
    t.text     "description"
    t.float    "quantity"
    t.integer  "unit_id"
    t.date     "used_date"
    t.datetime "deleted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "type"
    t.string   "order_number"
    t.integer  "created_by"
    t.integer  "branch_id"
    t.date     "order_date",       :null => false
    t.datetime "deleted_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "updated_by"
    t.string   "implement_status"
    t.datetime "received_at"
    t.datetime "done_at"
    t.string   "status"
  end

  create_table "positions", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.datetime "deleted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "units", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_branches", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.integer  "branch_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "name"
    t.string   "phone"
    t.string   "address"
    t.integer  "role_id"
    t.boolean  "su",                     :default => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token",                      :null => false
    t.datetime "deleted_at"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.datetime "token_expired"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
