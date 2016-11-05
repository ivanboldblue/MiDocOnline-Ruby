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

ActiveRecord::Schema.define(version: 20160328190650) do

  create_table "card_details", force: true do |t|
    t.integer  "patient_id"
    t.string   "card_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "validity"
    t.integer  "cvv"
    t.string   "number"
    t.integer  "user_id"
  end

  create_table "chat_messages", force: true do |t|
    t.integer  "chat_id"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chats", force: true do |t|
    t.integer  "patient_id"
    t.integer  "doctor_id"
    t.string   "chat_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.integer  "history_id"
    t.integer  "user_id"
  end

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "country_code"
    t.string   "mobile_no"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "devices", force: true do |t|
    t.integer  "user_id"
    t.text     "token"
    t.string   "device_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "histories", force: true do |t|
    t.integer  "receiver_id"
    t.integer  "caller_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_time"
    t.float    "duration"
    t.string   "chat_type"
    t.string   "call_status"
    t.boolean  "notified"
    t.float    "amount"
    t.string   "currency"
    t.string   "qb_caller_id"
    t.string   "qb_receiver_id"
    t.boolean  "paid_to_doctor"
    t.datetime "paid_date"
  end

  create_table "news_posts", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "post_type"
    t.date     "post_date"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "post_sub_type"
    t.boolean  "featured"
  end

  create_table "payments", force: true do |t|
    t.integer  "patient_id"
    t.string   "payment_type"
    t.float    "amount"
    t.datetime "payment_date"
    t.string   "txnid"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "specializations", force: true do |t|
    t.string   "specialization_type"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "specializations_users", id: false, force: true do |t|
    t.integer "doctor_id"
    t.integer "specialization_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                                              default: "", null: false
    t.string   "encrypted_password",                                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "username"
    t.string   "gender"
    t.string   "secret_key"
    t.string   "key"
    t.string   "address"
    t.text     "authentication_token"
    t.date     "dob"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin"
    t.string   "mobile_no"
    t.string   "facebook_id"
    t.string   "twitter_id"
    t.string   "location"
    t.boolean  "status"
    t.string   "type"
    t.string   "specialize"
    t.string   "surname"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "badge_count"
    t.string   "verification_code"
    t.string   "licence"
    t.string   "country"
    t.string   "city"
    t.string   "payment_verification_code"
    t.string   "mobile_verification_code"
    t.boolean  "mobile_verified"
    t.boolean  "terms_and_condition"
    t.float    "height"
    t.float    "weight"
    t.string   "blood_group"
    t.string   "zip_code"
    t.string   "street"
    t.text     "med_notes"
    t.string   "state"
    t.decimal  "qb_user_id",                precision: 10, scale: 0
    t.string   "qb_login"
    t.string   "qb_password"
    t.string   "qb_name"
    t.string   "emergency"
    t.datetime "from_time"
    t.datetime "to_time"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
