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

ActiveRecord::Schema.define(version: 2019_02_10_170741) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "base_category_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["base_category_id"], name: "index_categories_on_base_category_id"
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "goods", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "category_id"
    t.string "unit", null: false
    t.float "price", null: false
    t.string "remarks"
    t.string "picture"
    t.boolean "on_sale", default: true
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_goods_on_category_id"
    t.index ["name"], name: "index_goods_on_name"
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "store_id"
    t.bigint "good_id"
    t.integer "amount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["good_id"], name: "index_inventories_on_good_id"
    t.index ["store_id", "good_id"], name: "index_inventories_on_store_id_and_good_id", unique: true
    t.index ["store_id"], name: "index_inventories_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.datetime "deleted_at"
    t.index ["address"], name: "index_stores_on_address", unique: true
    t.index ["name"], name: "index_stores_on_name", unique: true
  end

  create_table "user_permissions", force: :cascade do |t|
    t.string "action", null: false
    t.string "obj_type"
    t.integer "obj_id"
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action", "obj_type", "obj_id"], name: "user_permissions_unique_index", unique: true
  end

  create_table "user_roles", force: :cascade do |t|
    t.string "name", null: false
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "user_roles_unique_index", unique: true
  end

  create_table "user_roles_and_user_permissions", id: false, force: :cascade do |t|
    t.bigint "user_role_id", null: false
    t.bigint "user_permission_id", null: false
    t.index ["user_permission_id"], name: "index_user_roles_and_user_permissions_on_user_permission_id"
    t.index ["user_role_id", "user_permission_id"], name: "user_roles_and_user_permissions_uniq_index", unique: true
    t.index ["user_role_id"], name: "index_user_roles_and_user_permissions_on_user_role_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "password_digest", null: false
    t.integer "token_version", default: 0
    t.string "email"
    t.string "phone_number"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
  end

  create_table "users_and_user_roles", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "user_role_id", null: false
    t.datetime "expire_at"
    t.index ["user_id", "user_role_id", "expire_at"], name: "users_and_user_roles_uniq_index", unique: true
    t.index ["user_id"], name: "index_users_and_user_roles_on_user_id"
    t.index ["user_role_id"], name: "index_users_and_user_roles_on_user_role_id"
  end

  create_table "verifications", force: :cascade do |t|
    t.bigint "user_id"
    t.string "code", null: false
    t.string "type", default: "phone"
    t.datetime "expire_at"
    t.datetime "verify_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_verifications_on_user_id"
  end

  add_foreign_key "goods", "categories"
  add_foreign_key "inventories", "goods"
  add_foreign_key "inventories", "stores"
  add_foreign_key "verifications", "users"
end
