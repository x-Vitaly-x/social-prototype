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

ActiveRecord::Schema.define(:version => 20120810230706) do

  create_table "albums", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "privacy"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "thumbnail"
    t.integer  "position"
    t.string   "album_type"
  end

  create_table "chat_messages", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.string   "content"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "news_entry_id"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.integer  "image_id"
  end

  create_table "entry_mappings", :force => true do |t|
    t.integer  "news_entry_id"
    t.integer  "map_entry_id"
    t.integer  "position"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "friendships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followee_id"
    t.string   "friendship_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "images", :force => true do |t|
    t.string   "s3_id"
    t.string   "visible_to"
    t.text     "description"
    t.integer  "album_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.integer  "privacy"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "type"
    t.integer  "position"
  end

  add_index "images", ["id"], :name => "index_images_on_id", :unique => true

  create_table "map_entries", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.float    "lat"
    t.float    "lng"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "news_entries", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "approved"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name_first"
    t.string   "name_last"
    t.string   "nickname"
    t.boolean  "gender"
    t.string   "facebook_avatar_url"
    t.integer  "facebook_id"
    t.string   "vkontakte_avatar_url"
    t.integer  "vkontakte_id"
    t.string   "username"
    t.boolean  "admin"
    t.integer  "avatar_id"
    t.text     "description"
    t.text     "settings"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
