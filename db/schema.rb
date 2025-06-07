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

ActiveRecord::Schema[8.0].define(version: 2025_06_07_025342) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name"
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
    t.decimal "cost"
    t.string "unit_of_measurement"
    t.string "image"
    t.float "weight"
    t.bigint "supplier_id", null: false
    t.bigint "input_type_id", null: false
    t.bigint "brand_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_inputs_on_brand_id"
    t.index ["input_type_id"], name: "index_inputs_on_input_type_id"
    t.index ["supplier_id"], name: "index_inputs_on_supplier_id"
  end

  create_table "product_subproducts", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "subproduct_id", null: false
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["brand_id"], name: "index_products_on_brand_id"
  end

  create_table "subproduct_inputs", force: :cascade do |t|
    t.bigint "subproduct_id", null: false
    t.bigint "input_id", null: false
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["input_id"], name: "index_subproduct_inputs_on_input_id"
    t.index ["subproduct_id"], name: "index_subproduct_inputs_on_subproduct_id"
  end

  create_table "subproducts", force: :cascade do |t|
    t.string "name"
    t.float "weight"
    t.float "cost"
    t.string "unit_of_measurement"
    t.bigint "brand_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_subproducts_on_brand_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "inputs", "brands"
  add_foreign_key "inputs", "input_types"
  add_foreign_key "inputs", "suppliers"
  add_foreign_key "product_subproducts", "products"
  add_foreign_key "product_subproducts", "subproducts"
  add_foreign_key "products", "brands"
  add_foreign_key "subproduct_inputs", "inputs"
  add_foreign_key "subproduct_inputs", "subproducts"
  add_foreign_key "subproducts", "brands"
end
