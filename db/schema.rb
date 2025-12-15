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

ActiveRecord::Schema[8.1].define(version: 2025_12_15_021152) do
  create_table "categories", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.integer "display_order", default: 0, null: false
    t.string "icon"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_categories_on_active"
    t.index ["display_order"], name: "index_categories_on_display_order"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "view_id", null: false
    t.index ["user_id"], name: "index_comments_on_user_id"
    t.index ["view_id"], name: "index_comments_on_view_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "nickname"
    t.string "profile_image"
    t.string "provider"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "uid"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "view_options", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "view_id", null: false
    t.index ["view_id"], name: "index_view_options_on_view_id"
  end

  create_table "views", force: :cascade do |t|
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "votes_count", default: 0, null: false
    t.index ["category_id"], name: "index_views_on_category_id"
    t.index ["created_at"], name: "index_views_on_created_at"
    t.index ["title"], name: "index_views_on_title"
    t.index ["user_id"], name: "index_views_on_user_id"
    t.index ["votes_count"], name: "index_views_on_votes_count"
  end

  create_table "votes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "view_option_id", null: false
    t.index ["user_id", "view_option_id"], name: "index_votes_on_user_id_and_view_option_id", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
    t.index ["view_option_id"], name: "index_votes_on_view_option_id"
  end

  add_foreign_key "comments", "users"
  add_foreign_key "comments", "views"
  add_foreign_key "view_options", "views"
  add_foreign_key "views", "categories"
  add_foreign_key "views", "users"
  add_foreign_key "votes", "users"
  add_foreign_key "votes", "view_options"
end
