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

ActiveRecord::Schema[8.0].define(version: 2025_07_19_155924) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "channels", force: :cascade do |t|
    t.string "description"
    t.decimal "channel_cost"
    t.string "channel_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "input_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inputs", force: :cascade do |t|
    t.string "name"
    t.decimal "cost", precision: 10, scale: 2
    t.string "unit_of_measurement"
    t.string "image"
    t.decimal "weight", precision: 10, scale: 2
    t.bigint "supplier_id", null: false
    t.bigint "input_type_id", null: false
    t.bigint "brand_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_inputs_on_brand_id"
    t.index ["input_type_id"], name: "index_inputs_on_input_type_id"
    t.index ["supplier_id"], name: "index_inputs_on_supplier_id"
  end

  create_table "package_compositions", force: :cascade do |t|
    t.bigint "package_id", null: false
    t.bigint "product_id", null: false
    t.float "weight"
    t.decimal "discount"
    t.decimal "price"
    t.decimal "subprice"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["package_id"], name: "index_package_compositions_on_package_id"
    t.index ["product_id"], name: "index_package_compositions_on_product_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "description"
    t.bigint "brand_id", null: false
    t.bigint "channel_id", null: false
    t.float "total_weight"
    t.decimal "general_discount", precision: 5, scale: 2
    t.decimal "subtotal_price", precision: 10, scale: 2
    t.decimal "total_price", precision: 10, scale: 2
    t.decimal "final_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_packages_on_brand_id"
    t.index ["channel_id"], name: "index_packages_on_channel_id"
  end

  create_table "product_subproducts", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "subproduct_id", null: false
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "cost", default: "0.0", null: false
    t.index ["product_id"], name: "index_product_subproducts_on_product_id"
    t.index ["subproduct_id"], name: "index_product_subproducts_on_subproduct_id"
  end

  create_table "products", force: :cascade do |t|
    t.text "description"
    t.string "unit_of_measurement"
    t.float "tax"
    t.float "financial_cost"
    t.float "total_weight"
    t.float "total_cost"
    t.float "profit_margin_retail"
    t.float "profit_margin_wholesale"
    t.float "sale_price_retail"
    t.float "sale_price_wholesale"
    t.bigint "brand_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "sales_channel_cost", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "commission_cost", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "freight_cost", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "storage_cost", precision: 8, scale: 2, default: "0.0", null: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
  end

  create_table "sales_targets", force: :cascade do |t|
    t.bigint "package_id", null: false
    t.integer "monthly_target"
    t.bigint "channel_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_sales_targets_on_channel_id"
    t.index ["package_id"], name: "index_sales_targets_on_package_id"
  end

  create_table "subproduct_compositions", force: :cascade do |t|
    t.bigint "subproduct_id", null: false
    t.bigint "input_id", null: false
    t.float "quantity_for_a_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "quantity_cost", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["input_id"], name: "index_subproduct_compositions_on_input_id"
    t.index ["subproduct_id"], name: "index_subproduct_compositions_on_subproduct_id"
  end

  create_table "subproducts", force: :cascade do |t|
    t.string "name"
    t.float "weight_in_grams"
    t.float "cost"
    t.string "unit_of_measurement"
    t.bigint "brand_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_subproducts_on_brand_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "inputs", "brands"
  add_foreign_key "inputs", "input_types"
  add_foreign_key "inputs", "suppliers"
  add_foreign_key "package_compositions", "packages"
  add_foreign_key "package_compositions", "products"
  add_foreign_key "packages", "brands"
  add_foreign_key "packages", "channels"
  add_foreign_key "product_subproducts", "products"
  add_foreign_key "product_subproducts", "subproducts"
  add_foreign_key "products", "brands"
  add_foreign_key "sales_targets", "channels"
  add_foreign_key "sales_targets", "packages"
  add_foreign_key "subproduct_compositions", "inputs"
  add_foreign_key "subproduct_compositions", "subproducts"
  add_foreign_key "subproducts", "brands"
end
