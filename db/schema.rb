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

ActiveRecord::Schema[8.0].define(version: 2025_10_16_194450) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

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

  create_table "banner_clients", force: :cascade do |t|
    t.bigint "banner_id", null: false
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["banner_id"], name: "index_banner_clients_on_banner_id"
    t.index ["client_id"], name: "index_banner_clients_on_client_id"
  end

  create_table "banners", force: :cascade do |t|
    t.string "image"
    t.string "link"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "interval", default: 5000, null: false
    t.integer "plan_id"
    t.index ["plan_id"], name: "index_banners_on_plan_id"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "main_brand", default: false, null: false
    t.bigint "client_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
  end

  create_table "channel_product_portions", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "product_portion_id", null: false
    t.bigint "channel_id", null: false
    t.decimal "corrected_final_price", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "effective_final_price"
    t.index ["client_id", "product_portion_id", "channel_id"], name: "idx_cpp_unique", unique: true
  end

  create_table "channels", force: :cascade do |t|
    t.string "description"
    t.decimal "channel_cost"
    t.string "channel_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
  end

  create_table "client_plans", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_client_plans_on_client_id"
    t.index ["plan_id"], name: "index_client_plans_on_plan_id"
  end

  create_table "clients", force: :cascade do |t|
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
    t.index ["cnpj"], name: "index_clients_on_cnpj", unique: true
    t.index ["plan_id"], name: "index_clients_on_plan_id"
  end

  create_table "energies", force: :cascade do |t|
    t.string "description"
    t.decimal "consume_per_hour"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
  end

  create_table "equipments", force: :cascade do |t|
    t.string "description"
    t.decimal "value"
    t.float "depreciation_percent"
    t.decimal "depreciation_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
  end

  create_table "fixed_costs", force: :cascade do |t|
    t.string "description"
    t.decimal "monthly_cost"
    t.string "fixed_cost_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
  end

  create_table "input_cost_histories", force: :cascade do |t|
    t.bigint "input_id", null: false
    t.decimal "cost", precision: 10, scale: 2, null: false
    t.datetime "recorded_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
    t.index ["input_id"], name: "index_input_cost_histories_on_input_id"
    t.index ["recorded_at"], name: "index_input_cost_histories_on_recorded_at"
  end

  create_table "input_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id", null: false
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
    t.bigint "client_id"
    t.float "total_fat"
    t.float "protein"
    t.float "carbs"
    t.float "dietary_fiber"
    t.float "sugars"
    t.float "sodium"
    t.float "calories"
    t.index ["brand_id"], name: "index_inputs_on_brand_id"
    t.index ["input_type_id"], name: "index_inputs_on_input_type_id"
    t.index ["supplier_id"], name: "index_inputs_on_supplier_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.text "client_ids_text"
    t.string "plans", default: [], array: true
    t.date "start_date"
    t.date "end_date"
    t.time "start_hour"
    t.time "end_hour"
    t.string "created_by_type"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_type", "created_by_id"], name: "index_system_admins_messages_on_created_by"
  end

  create_table "messages_plans", id: false, force: :cascade do |t|
    t.bigint "message_id", null: false
    t.bigint "plan_id", null: false
  end

  create_table "packages", force: :cascade do |t|
    t.string "description"
    t.bigint "supplier_id", null: false
    t.float "unit_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
    t.index ["client_id"], name: "index_packages_on_client_id"
    t.index ["supplier_id"], name: "index_packages_on_supplier_id"
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

  create_table "plans", force: :cascade do |t|
    t.string "description"
    t.decimal "price"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "portion_packages", force: :cascade do |t|
    t.bigint "product_portion_id", null: false
    t.bigint "package_id", null: false
    t.integer "package_units"
    t.float "total_package_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
    t.index ["client_id"], name: "index_portion_packages_on_client_id"
    t.index ["package_id"], name: "index_portion_packages_on_package_id"
    t.index ["product_portion_id"], name: "index_portion_packages_on_product_portion_id"
  end

  create_table "price_list_rules", force: :cascade do |t|
    t.bigint "price_list_id", null: false
    t.bigint "product_portion_id", null: false
    t.bigint "channel_id", null: false
    t.string "unit_type"
    t.decimal "initial_quantity"
    t.decimal "final_quantity"
    t.string "discount_type"
    t.decimal "discount_value"
    t.decimal "final_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_price_list_rules_on_channel_id"
    t.index ["price_list_id"], name: "index_price_list_rules_on_price_list_id"
    t.index ["product_portion_id"], name: "index_price_list_rules_on_product_portion_id"
  end

  create_table "price_lists", force: :cascade do |t|
    t.string "description"
    t.bigint "product_portion_id", null: false
    t.string "list_type"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_portion_id"], name: "index_price_lists_on_product_portion_id"
  end

  create_table "product_portions", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.float "portioned_quantity"
    t.float "final_package_price"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
    t.decimal "fixed_cost", precision: 10, scale: 2
    t.bigint "tax_id"
    t.decimal "final_cost"
    t.decimal "final_price"
    t.decimal "profit_margin"
    t.decimal "cost", precision: 12, scale: 2
    t.index ["client_id"], name: "index_product_portions_on_client_id"
    t.index ["product_id"], name: "index_product_portions_on_product_id"
    t.index ["tax_id"], name: "index_product_portions_on_tax_id"
  end

  create_table "product_subproducts", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "subproduct_id", null: false
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "cost", default: "0.0", null: false
    t.decimal "cost_per_gram_with_loss"
    t.bigint "client_id"
    t.decimal "calories", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_fat", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "protein", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "carbs", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "dietary_fiber", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "sugars", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "sodium", precision: 10, scale: 2, default: "0.0", null: false
    t.float "quantity_with_loss"
    t.index ["product_id"], name: "index_product_subproducts_on_product_id"
    t.index ["subproduct_id"], name: "index_product_subproducts_on_subproduct_id"
  end

  create_table "production_simulations", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id"
    t.decimal "quantity_in_grams", precision: 10, scale: 2, null: false
    t.decimal "total_quantity", precision: 10, scale: 2
    t.decimal "total_cost", precision: 12, scale: 2
    t.decimal "minimum_selling_price", precision: 12, scale: 2
    t.decimal "total_selling_price", precision: 12, scale: 2
    t.decimal "total_retail_profit", precision: 12, scale: 2
    t.decimal "total_wholesale_profit", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "product_units"
    t.bigint "product_portion_id"
    t.decimal "total_profit"
    t.index ["client_id"], name: "index_production_simulations_on_client_id"
    t.index ["created_by_id"], name: "index_production_simulations_on_created_by_id"
    t.index ["product_portion_id"], name: "index_production_simulations_on_product_portion_id"
    t.index ["updated_by_id"], name: "index_production_simulations_on_updated_by_id"
  end

  create_table "products", force: :cascade do |t|
    t.text "description"
    t.float "total_weight"
    t.decimal "total_cost", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "brand_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.bigint "category_id"
    t.decimal "weight_loss", default: "0.0"
    t.decimal "final_weight", default: "0.0"
    t.bigint "client_id"
    t.decimal "calories", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_fat", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "protein", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "carbs", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "dietary_fiber", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "sugars", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "sodium", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "final_cost"
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["category_id"], name: "index_products_on_category_id"
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
    t.bigint "client_id"
    t.index ["role_id"], name: "index_professionals_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
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
    t.decimal "total_fixed_cost", precision: 10, scale: 2, default: "0.0"
    t.integer "sales_target_sum", default: 0, null: false
    t.integer "sales_target_active_sum", default: 0, null: false
    t.bigint "client_id"
    t.bigint "product_portion_id"
    t.index ["product_portion_id"], name: "index_sales_targets_on_product_portion_id"
  end

  create_table "service_energies", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "energy_id", null: false
    t.decimal "hours_per_service"
    t.decimal "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
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
    t.bigint "client_id"
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
    t.bigint "client_id"
    t.index ["input_id"], name: "index_service_inputs_on_input_id"
    t.index ["service_id"], name: "index_service_inputs_on_service_id"
  end

  create_table "service_products", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.decimal "quantity_for_service"
    t.decimal "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_portion_id"
    t.bigint "client_id"
    t.index ["client_id"], name: "index_service_products_on_client_id"
    t.index ["product_portion_id"], name: "index_service_products_on_product_portion_id"
    t.index ["service_id"], name: "index_service_products_on_service_id"
  end

  create_table "service_professionals", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "professional_id", null: false
    t.decimal "hourly_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
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
    t.bigint "client_id"
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
    t.bigint "client_id"
    t.index ["professional_id"], name: "index_services_on_professional_id"
    t.index ["role_id"], name: "index_services_on_role_id"
  end

  create_table "simulation_inputs", force: :cascade do |t|
    t.bigint "production_simulation_id", null: false
    t.bigint "input_id", null: false
    t.decimal "total_quantity", precision: 10, scale: 2
    t.decimal "total_cost", precision: 12, scale: 2
    t.decimal "required_units", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["input_id"], name: "index_simulation_inputs_on_input_id"
    t.index ["production_simulation_id"], name: "index_simulation_inputs_on_production_simulation_id"
  end

  create_table "simulation_products", force: :cascade do |t|
    t.bigint "production_simulation_id", null: false
    t.decimal "total_quantity", precision: 10, scale: 2
    t.decimal "total_cost", precision: 12, scale: 2
    t.decimal "minimum_selling_price", precision: 12, scale: 2
    t.decimal "total_selling_price", precision: 12, scale: 2
    t.decimal "total_retail_profit", precision: 12, scale: 2
    t.decimal "total_wholesale_profit", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_portion_id"
    t.decimal "total_profit"
    t.index ["product_portion_id"], name: "index_simulation_products_on_product_portion_id"
    t.index ["production_simulation_id"], name: "index_simulation_products_on_production_simulation_id"
  end

  create_table "simulation_subproducts", force: :cascade do |t|
    t.bigint "production_simulation_id", null: false
    t.bigint "subproduct_id", null: false
    t.decimal "total_quantity", precision: 10, scale: 2
    t.decimal "total_cost", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["production_simulation_id"], name: "index_simulation_subproducts_on_production_simulation_id"
    t.index ["subproduct_id"], name: "index_simulation_subproducts_on_subproduct_id"
  end

  create_table "subproduct_compositions", force: :cascade do |t|
    t.bigint "subproduct_id", null: false
    t.bigint "input_id", null: false
    t.float "quantity_for_a_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "quantity_cost", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "client_id"
    t.decimal "calories", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_fat", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "protein", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "carbs", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "dietary_fiber", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "sugars", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "sodium", precision: 10, scale: 2, default: "0.0", null: false
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
    t.bigint "client_id"
    t.decimal "calories", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_fat", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "protein", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "carbs", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "dietary_fiber", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "sugars", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "sodium", precision: 10, scale: 2, default: "0.0", null: false
    t.index ["brand_id"], name: "index_subproducts_on_brand_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
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
    t.bigint "client_id"
  end

  create_table "user_admins", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "phone"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.boolean "super_admin", default: false, null: false
    t.index ["confirmation_token"], name: "index_user_admins_on_confirmation_token", unique: true
    t.index ["reset_password_token"], name: "index_user_admins_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_user_admins_on_unlock_token", unique: true
  end

  create_table "user_clients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.string "email", default: "", null: false
    t.string "first_name", limit: 100
    t.string "last_name", limit: 100
    t.boolean "admin"
    t.bigint "client_id"
    t.date "signup_date"
    t.index ["client_id"], name: "index_user_clients_on_client_id"
    t.index ["confirmation_token"], name: "index_user_clients_on_confirmation_token", unique: true
    t.index ["email"], name: "index_user_clients_on_email", unique: true
    t.index ["reset_password_token"], name: "index_user_clients_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "banner_clients", "banners"
  add_foreign_key "banner_clients", "clients"
  add_foreign_key "brands", "clients", name: "fk_brands_client"
  add_foreign_key "categories", "clients", name: "fk_categories_client"
  add_foreign_key "channel_product_portions", "channels"
  add_foreign_key "channel_product_portions", "product_portions"
  add_foreign_key "channels", "clients", name: "fk_channels_client"
  add_foreign_key "client_plans", "clients"
  add_foreign_key "client_plans", "plans"
  add_foreign_key "clients", "plans"
  add_foreign_key "energies", "clients", name: "fk_energies_client"
  add_foreign_key "equipments", "clients", name: "fk_equipments_client"
  add_foreign_key "fixed_costs", "clients", name: "fk_fixed_costs_client"
  add_foreign_key "input_cost_histories", "clients", name: "fk_input_cost_histories_client"
  add_foreign_key "input_cost_histories", "inputs"
  add_foreign_key "input_types", "clients", name: "fk_input_types_clients"
  add_foreign_key "inputs", "brands"
  add_foreign_key "inputs", "clients", name: "fk_inputs_client"
  add_foreign_key "inputs", "input_types"
  add_foreign_key "inputs", "suppliers"
  add_foreign_key "packages", "clients"
  add_foreign_key "packages", "suppliers"
  add_foreign_key "payment_method_installments", "payment_methods"
  add_foreign_key "portion_packages", "clients"
  add_foreign_key "portion_packages", "packages"
  add_foreign_key "portion_packages", "product_portions"
  add_foreign_key "price_list_rules", "channels"
  add_foreign_key "price_list_rules", "price_lists"
  add_foreign_key "price_list_rules", "product_portions"
  add_foreign_key "price_lists", "product_portions"
  add_foreign_key "product_portions", "clients"
  add_foreign_key "product_portions", "products"
  add_foreign_key "product_portions", "taxes"
  add_foreign_key "product_subproducts", "clients", name: "fk_product_subproducts_client"
  add_foreign_key "product_subproducts", "products"
  add_foreign_key "product_subproducts", "subproducts"
  add_foreign_key "production_simulations", "clients"
  add_foreign_key "production_simulations", "product_portions"
  add_foreign_key "production_simulations", "user_clients", column: "created_by_id"
  add_foreign_key "production_simulations", "user_clients", column: "updated_by_id"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "clients", name: "fk_products_client"
  add_foreign_key "professionals", "clients", name: "fk_professionals_client"
  add_foreign_key "professionals", "roles"
  add_foreign_key "roles", "clients", name: "fk_roles_client"
  add_foreign_key "sales_orders", "sales_quotes"
  add_foreign_key "sales_quotes", "sales_clients", column: "client_id"
  add_foreign_key "sales_targets", "product_portions"
  add_foreign_key "service_energies", "clients", name: "fk_service_energies_client"
  add_foreign_key "service_energies", "energies"
  add_foreign_key "service_energies", "services"
  add_foreign_key "service_equipments", "clients", name: "fk_service_equipments_client"
  add_foreign_key "service_equipments", "equipments"
  add_foreign_key "service_equipments", "services"
  add_foreign_key "service_inputs", "clients", name: "fk_service_inputs_client"
  add_foreign_key "service_inputs", "inputs"
  add_foreign_key "service_inputs", "services"
  add_foreign_key "service_products", "clients"
  add_foreign_key "service_products", "product_portions"
  add_foreign_key "service_products", "services"
  add_foreign_key "service_professionals", "clients", name: "fk_service_professionals_client"
  add_foreign_key "service_professionals", "professionals"
  add_foreign_key "service_professionals", "services"
  add_foreign_key "service_subproducts", "clients", name: "fk_service_subproducts_client"
  add_foreign_key "service_subproducts", "services"
  add_foreign_key "service_subproducts", "subproducts"
  add_foreign_key "services", "clients", name: "fk_services_client"
  add_foreign_key "services", "professionals"
  add_foreign_key "services", "roles"
  add_foreign_key "simulation_inputs", "inputs"
  add_foreign_key "simulation_inputs", "production_simulations"
  add_foreign_key "simulation_products", "product_portions"
  add_foreign_key "simulation_products", "production_simulations"
  add_foreign_key "simulation_subproducts", "production_simulations"
  add_foreign_key "simulation_subproducts", "subproducts"
  add_foreign_key "subproduct_compositions", "clients", name: "fk_subproduct_compositions_client"
  add_foreign_key "subproduct_compositions", "inputs"
  add_foreign_key "subproduct_compositions", "subproducts"
  add_foreign_key "subproducts", "brands"
  add_foreign_key "subproducts", "clients", name: "fk_subproducts_client"
  add_foreign_key "suppliers", "clients", name: "fk_suppliers_client"
  add_foreign_key "taxes", "clients", name: "fk_taxes_client"
  add_foreign_key "user_clients", "clients"
end
