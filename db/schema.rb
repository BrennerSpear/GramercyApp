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

ActiveRecord::Schema.define(version: 20150913012850) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",    default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "brands", force: :cascade do |t|
    t.text     "email",                  default: "",  null: false
    t.text     "encrypted_password",     default: "",  null: false
    t.text     "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.text     "current_sign_in_ip"
    t.text     "last_sign_in_ip"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "uid"
    t.string   "nickname"
    t.string   "name"
    t.string   "image"
    t.string   "bio"
    t.string   "website"
    t.string   "token"
    t.integer  "cents_per_like"
    t.float    "dollars_per_follow"
    t.integer  "days_to_post"
    t.float    "max_total_allowed"
    t.string   "follower_count",         default: "0", null: false
    t.string   "following_count",        default: "0", null: false
    t.string   "media_count",            default: "0", null: false
  end

  add_index "brands", ["email"], name: "index_brands_on_email", unique: true, using: :btree
  add_index "brands", ["reset_password_token"], name: "index_brands_on_reset_password_token", unique: true, using: :btree
  add_index "brands", ["uid"], name: "index_brands_on_uid", unique: true, using: :btree

  create_table "followed_bys", force: :cascade do |t|
    t.integer  "followable_id",   null: false
    t.string   "followable_type", null: false
    t.integer  "follower_id",     null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "followed_bys", ["followable_type", "followable_id"], name: "index_followed_bys_on_followable_type_and_followable_id", using: :btree
  add_index "followed_bys", ["follower_id"], name: "index_followed_bys_on_follower_id", using: :btree

  create_table "followers", force: :cascade do |t|
    t.string   "username"
    t.string   "profile_picture"
    t.string   "uid",             null: false
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "leads", force: :cascade do |t|
    t.text     "email"
    t.text     "platform"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "shop_id",            null: false
    t.integer  "cents_per_like",     null: false
    t.float    "dollars_per_follow", null: false
    t.float    "max_total_allowed",  null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "email"
    t.datetime "expires_at",         null: false
  end

  add_index "orders", ["created_at"], name: "index_orders_on_created_at", using: :btree
  add_index "orders", ["shop_id"], name: "index_orders_on_shop_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "shopper_id",                       null: false
    t.integer  "order_id"
    t.string   "media_type",                       null: false
    t.text     "caption"
    t.string   "link",                             null: false
    t.string   "image",                            null: false
    t.string   "media_id",                         null: false
    t.text     "tagged_accounts",     default: [],              array: true
    t.integer  "likes",               default: 0,  null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "followers_generated", default: [],              array: true
  end

  add_index "posts", ["created_at"], name: "index_posts_on_created_at", using: :btree
  add_index "posts", ["order_id"], name: "index_posts_on_order_id", using: :btree
  add_index "posts", ["shopper_id"], name: "index_posts_on_shopper_id", using: :btree

  create_table "rewards", force: :cascade do |t|
    t.integer  "post_id",             null: false
    t.float    "payable_total",       null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.float    "calculated_total"
    t.integer  "followers_generated"
    t.integer  "likes"
    t.integer  "cents_per_like"
    t.float    "dollars_per_follow"
    t.float    "max_total_allowed"
  end

  add_index "rewards", ["post_id"], name: "index_rewards_on_post_id", using: :btree

  create_table "shoppers", force: :cascade do |t|
    t.string   "email",                  default: "",  null: false
    t.string   "encrypted_password",     default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "nickname"
    t.string   "name"
    t.string   "image"
    t.string   "bio"
    t.string   "website"
    t.string   "token"
    t.string   "follower_count",         default: "0", null: false
    t.string   "following_count",        default: "0", null: false
    t.string   "media_count",            default: "0", null: false
  end

  add_index "shoppers", ["email"], name: "index_shoppers_on_email", unique: true, using: :btree
  add_index "shoppers", ["provider"], name: "index_shoppers_on_provider", using: :btree
  add_index "shoppers", ["reset_password_token"], name: "index_shoppers_on_reset_password_token", unique: true, using: :btree
  add_index "shoppers", ["uid"], name: "index_shoppers_on_uid", unique: true, using: :btree

  create_table "shops", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brand_id",   null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "store_hash"
    t.string   "stripe_id"
  end

  add_index "shops", ["brand_id"], name: "index_shops_on_brand_id", using: :btree

  create_table "sidekiq_jobs", force: :cascade do |t|
    t.string   "jid"
    t.string   "queue"
    t.string   "class_name"
    t.text     "args"
    t.boolean  "retry"
    t.datetime "enqueued_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string   "status"
    t.string   "name"
    t.text     "result"
  end

  add_index "sidekiq_jobs", ["class_name"], name: "index_sidekiq_jobs_on_class_name", using: :btree
  add_index "sidekiq_jobs", ["enqueued_at"], name: "index_sidekiq_jobs_on_enqueued_at", using: :btree
  add_index "sidekiq_jobs", ["finished_at"], name: "index_sidekiq_jobs_on_finished_at", using: :btree
  add_index "sidekiq_jobs", ["jid"], name: "index_sidekiq_jobs_on_jid", using: :btree
  add_index "sidekiq_jobs", ["queue"], name: "index_sidekiq_jobs_on_queue", using: :btree
  add_index "sidekiq_jobs", ["retry"], name: "index_sidekiq_jobs_on_retry", using: :btree
  add_index "sidekiq_jobs", ["started_at"], name: "index_sidekiq_jobs_on_started_at", using: :btree
  add_index "sidekiq_jobs", ["status"], name: "index_sidekiq_jobs_on_status", using: :btree

end
