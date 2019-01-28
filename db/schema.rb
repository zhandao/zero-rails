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

ActiveRecord::Schema.define(version: 2017_10_20_172654) do

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

  create_table "entity_permissions", force: :cascade do |t|
    t.string "entity_type"
    t.bigint "entity_id"
    t.bigint "permission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id", "entity_type", "permission_id"], name: "entity_permission_unique_index", unique: true
    t.index ["entity_type", "entity_id"], name: "index_entity_permissions_on_entity_type_and_entity_id"
    t.index ["permission_id"], name: "index_entity_permissions_on_permission_id"
  end

  create_table "entity_roles", force: :cascade do |t|
    t.string "entity_type"
    t.bigint "entity_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id", "entity_type", "role_id"], name: "entity_roles_unique_index", unique: true
    t.index ["entity_type", "entity_id"], name: "index_entity_roles_on_entity_type_and_entity_id"
    t.index ["role_id"], name: "index_entity_roles_on_role_id"
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

  create_table "permissions", force: :cascade do |t|
    t.string "name", null: false
    t.string "source_type"
    t.bigint "source_id"
    t.string "model", default: "User", null: false
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "source_type", "source_id", "model"], name: "permission_unique_index", unique: true
    t.index ["source_type", "source_id"], name: "index_permissions_on_source_type_and_source_id"
  end

  create_table "role_permissions", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "permission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id"
    t.index ["role_id", "permission_id"], name: "index_role_permissions_on_role_id_and_permission_id", unique: true
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.string "model", default: "User", null: false
    t.string "remarks"
    t.bigint "base_role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["base_role_id"], name: "index_roles_on_base_role_id"
    t.index ["name", "model"], name: "role_unique_index", unique: true
  end

  create_table "stores", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.datetime "deleted_at"
    t.index ["address"], name: "index_stores_on_address", unique: true
    t.index ["name"], name: "index_stores_on_name", unique: true
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

  add_foreign_key "entity_permissions", "permissions"
  add_foreign_key "entity_roles", "roles"
  add_foreign_key "goods", "categories"
  add_foreign_key "inventories", "goods"
  add_foreign_key "inventories", "stores"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "verifications", "users"
end
