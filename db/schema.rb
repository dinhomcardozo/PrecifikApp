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

ActiveRecord::Schema[8.0].define(version: 2025_08_17_154334) do
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
    t.boolean "main_brand", default: false, null: false
  end

  create_table "categories", force: :cascade do |t|
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

  create_table "energies", force: :cascade do |t|
    t.string "description"
    t.decimal "consume_per_hour"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipments", force: :cascade do |t|
    t.string "description"
    t.decimal "value"
    t.float "depreciation_percent"
    t.decimal "depreciation_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fixed_costs", force: :cascade do |t|
    t.string "description"
    t.decimal "monthly_cost"
    t.string "fixed_cost_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "input_cost_histories", force: :cascade do |t|
    t.bigint "input_id", null: false
    t.decimal "cost", precision: 10, scale: 2, null: false
    t.datetime "recorded_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["input_id"], name: "index_input_cost_histories_on_input_id"
    t.index ["recorded_at"], name: "index_input_cost_histories_on_recorded_at"
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

  create_table "payment_method_installments", force: :cascade do |t|
    t.bigint "payment_method_id", null: false
    t.integer "installment_count"
    t.decimal "percentage_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_method_id"], name: "index_payment_method_installments_on_payment_method_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "fee_type"
    t.decimal "fee_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_payment_methods_on_code"
  end

  create_table "product_subproducts", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "subproduct_id", null: false
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "cost", default: "0.0", null: false
    t.decimal "cost_per_gram_with_loss"
    t.index ["product_id"], name: "index_product_subproducts_on_product_id"
    t.index ["subproduct_id"], name: "index_product_subproducts_on_subproduct_id"
  end

  create_table "products", force: :cascade do |t|
    t.text "description"
    t.float "total_weight"
    t.decimal "total_cost", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "profit_margin_retail", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "profit_margin_wholesale", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "brand_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tax_id"
    t.decimal "total_taxes"
    t.decimal "suggested_price_retail", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "suggested_price_wholesale", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_cost_with_taxes", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_cost_with_fixed_costs", precision: 10, scale: 2, default: "0.0", null: false
    t.string "image"
    t.bigint "category_id"
    t.decimal "weight_loss", default: "0.0"
    t.decimal "final_weight", default: "0.0"
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["tax_id"], name: "index_products_on_tax_id"
  end

  create_table "professionals", force: :cascade do |t|
    t.string "full_name"
    t.bigint "role_id", null: false
    t.string "cpf"
    t.string "company_name"
    t.string "cnpj"
    t.decimal "average_hourly_rate"
    t.decimal "hourly_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_professionals_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sales_clients", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "company"
    t.string "cnpj"
    t.string "phone"
    t.string "email"
    t.string "address"
    t.string "number_address"
    t.string "city"
    t.string "state"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sales_orders", force: :cascade do |t|
    t.bigint "sales_quote_id", null: false
    t.string "status"
    t.datetime "placed_at"
    t.decimal "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sales_quote_id"], name: "index_sales_orders_on_sales_quote_id"
  end

  create_table "sales_quotes", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.decimal "channel_cost"
    t.decimal "bank_slip_cost"
    t.decimal "card_cost"
    t.string "status"
    t.decimal "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_sales_quotes_on_client_id"
  end

  create_table "sales_targets", force: :cascade do |t|
    t.integer "monthly_target"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id", null: false
    t.decimal "total_fixed_cost", precision: 10, scale: 2, default: "0.0"
    t.integer "sales_target_sum", default: 0, null: false
    t.integer "sales_target_active_sum", default: 0, null: false
    t.index ["product_id"], name: "index_sales_targets_on_product_id"
  end

  create_table "service_energies", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "energy_id", null: false
    t.decimal "hours_per_service"
    t.decimal "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["energy_id"], name: "index_service_energies_on_energy_id"
    t.index ["service_id"], name: "index_service_energies_on_service_id"
  end

  create_table "service_equipments", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "equipment_id", null: false
    t.decimal "hours_per_service"
    t.decimal "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_service_equipments_on_equipment_id"
    t.index ["service_id"], name: "index_service_equipments_on_service_id"
  end

  create_table "service_inputs", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "input_id", null: false
    t.decimal "quantity_for_service"
    t.decimal "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["input_id"], name: "index_service_inputs_on_input_id"
    t.index ["service_id"], name: "index_service_inputs_on_service_id"
  end

  create_table "service_products", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "product_id", null: false
    t.decimal "quantity_for_service"
    t.decimal "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_service_products_on_product_id"
    t.index ["service_id"], name: "index_service_products_on_service_id"
  end

  create_table "service_professionals", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "professional_id", null: false
    t.decimal "hourly_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["professional_id"], name: "index_service_professionals_on_professional_id"
    t.index ["service_id"], name: "index_service_professionals_on_service_id"
  end

  create_table "service_subproducts", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "subproduct_id", null: false
    t.decimal "quantity_for_service"
    t.decimal "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_service_subproducts_on_service_id"
    t.index ["subproduct_id"], name: "index_service_subproducts_on_subproduct_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "description"
    t.bigint "role_id", null: false
    t.integer "total_seconds"
    t.float "tax"
    t.float "profit_margin"
    t.decimal "final_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "professional_id", null: false
    t.float "total_hours", null: false
    t.decimal "service_items_cost", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "service_price", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "final_service_price", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["professional_id"], name: "index_services_on_professional_id"
    t.index ["role_id"], name: "index_services_on_role_id"
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
    t.decimal "weight_loss", default: "0.0"
    t.decimal "final_weight", default: "0.0"
    t.index ["brand_id"], name: "index_subproducts_on_brand_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_admins_banners", force: :cascade do |t|
    t.string "image"
    t.string "link"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "interval", default: 5000, null: false
  end

  create_table "system_admins_client_plans", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_system_admins_client_plans_on_client_id"
    t.index ["plan_id"], name: "index_system_admins_client_plans_on_plan_id"
  end

  create_table "system_admins_clients", force: :cascade do |t|
    t.string "razao_social"
    t.string "company_name"
    t.string "cnpj"
    t.string "first_name"
    t.string "last_name"
    t.string "cpf"
    t.string "phone"
    t.string "address"
    t.integer "number_address"
    t.bigint "plan_id", null: false
    t.date "signup_date"
    t.date "first_payment"
    t.date "last_payment"
    t.datetime "first_login"
    t.datetime "last_login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_system_admins_clients_on_plan_id"
  end

  create_table "system_admins_plans", force: :cascade do |t|
    t.string "description"
    t.decimal "price"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_admins_user_admins", force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "phone"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_admins_user_clients", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_system_admins_user_clients_on_client_id"
    t.index ["user_id"], name: "index_system_admins_user_clients_on_user_id"
  end

  create_table "system_admins_users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.boolean "admin"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_system_admins_users_on_client_id"
  end

  create_table "taxes", force: :cascade do |t|
    t.text "description"
    t.decimal "icms"
    t.decimal "ipi"
    t.decimal "pis_cofins"
    t.decimal "difal"
    t.decimal "iss"
    t.decimal "cbs"
    t.decimal "ibs"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "input_cost_histories", "inputs"
  add_foreign_key "inputs", "brands"
  add_foreign_key "inputs", "input_types"
  add_foreign_key "inputs", "suppliers"
  add_foreign_key "payment_method_installments", "payment_methods"
  add_foreign_key "product_subproducts", "products"
  add_foreign_key "product_subproducts", "subproducts"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "taxes"
  add_foreign_key "professionals", "roles"
  add_foreign_key "sales_orders", "sales_quotes"
  add_foreign_key "sales_quotes", "sales_clients", column: "client_id"
  add_foreign_key "sales_targets", "products"
  add_foreign_key "service_energies", "energies"
  add_foreign_key "service_energies", "services"
  add_foreign_key "service_equipments", "equipments"
  add_foreign_key "service_equipments", "services"
  add_foreign_key "service_inputs", "inputs"
  add_foreign_key "service_inputs", "services"
  add_foreign_key "service_products", "products"
  add_foreign_key "service_products", "services"
  add_foreign_key "service_professionals", "professionals"
  add_foreign_key "service_professionals", "services"
  add_foreign_key "service_subproducts", "services"
  add_foreign_key "service_subproducts", "subproducts"
  add_foreign_key "services", "professionals"
  add_foreign_key "services", "roles"
  add_foreign_key "subproduct_compositions", "inputs"
  add_foreign_key "subproduct_compositions", "subproducts"
  add_foreign_key "subproducts", "brands"
  add_foreign_key "system_admins_client_plans", "system_admins_clients", column: "client_id"
  add_foreign_key "system_admins_client_plans", "system_admins_plans", column: "plan_id"
  add_foreign_key "system_admins_clients", "system_admins_plans", column: "plan_id"
  add_foreign_key "system_admins_user_clients", "system_admins_clients", column: "client_id"
  add_foreign_key "system_admins_user_clients", "system_admins_users", column: "user_id"
  add_foreign_key "system_admins_users", "system_admins_clients", column: "client_id"
end
