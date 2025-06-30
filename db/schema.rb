# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_06_30_080517) do
  create_table "active_admin_comments", charset: "utf8mb3", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "favorites", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "flower_mountain_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flower_mountain_id"], name: "index_favorites_on_flower_mountain_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "flower_mountains", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "flower_id", null: false
    t.bigint "mountain_id", null: false
    t.integer "peak_month"
    t.text "bloom_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flower_id"], name: "index_flower_mountains_on_flower_id"
    t.index ["mountain_id"], name: "index_flower_mountains_on_mountain_id"
  end

  create_table "flowers", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "scientific_name"
    t.integer "bloom_start_month"
    t.integer "bloom_end_month"
    t.text "description"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_likes_on_post_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "mountains", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "region"
    t.string "difficulty_level"
    t.integer "elevation"
    t.decimal "latitude", precision: 10
    t.decimal "longitude", precision: 10
    t.text "description"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "flower_mountain_id", null: false
    t.integer "days_before"
    t.date "notification_date"
    t.boolean "sent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notification_type", default: "reminder", null: false
    t.string "url"
    t.index ["flower_mountain_id"], name: "index_notifications_on_flower_mountain_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "post_likes", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_likes_on_post_id"
    t.index ["user_id", "post_id"], name: "index_post_likes_on_user_id_and_post_id", unique: true
    t.index ["user_id"], name: "index_post_likes_on_user_id"
  end

  create_table "posts", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "content"
    t.string "image_url"
    t.integer "likes_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "flower_id", null: false
    t.bigint "mountain_id", null: false
    t.index ["flower_id"], name: "index_posts_on_flower_id"
    t.index ["mountain_id"], name: "index_posts_on_mountain_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "nickname", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "first_name_kana", default: "", null: false
    t.string "last_name_kana", default: "", null: false
    t.date "birth_date", null: false
    t.string "region"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["region"], name: "index_users_on_region"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "favorites", "flower_mountains"
  add_foreign_key "favorites", "users"
  add_foreign_key "flower_mountains", "flowers"
  add_foreign_key "flower_mountains", "mountains"
  add_foreign_key "likes", "posts"
  add_foreign_key "likes", "users"
  add_foreign_key "notifications", "flower_mountains"
  add_foreign_key "notifications", "users"
  add_foreign_key "post_likes", "posts"
  add_foreign_key "post_likes", "users"
  add_foreign_key "posts", "users"
end
