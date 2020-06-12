ActiveRecord::Schema.define(version: 2020_06_12_162737) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "category_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories_products", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "product_id"
    t.index ["category_id"], name: "index_categories_products_on_category_id"
    t.index ["product_id"], name: "index_categories_products_on_product_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.bigint "provider"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "orderitems", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "shipped"
    t.bigint "order_id"
    t.bigint "product_id"
    t.bigint "quantity"
    t.index ["order_id"], name: "index_orderitems_on_order_id"
    t.index ["product_id"], name: "index_orderitems_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "total"
    t.string "status"
    t.string "email"
    t.string "address"
    t.string "cc_name"
    t.bigint "cc_num"
    t.integer "cvv"
    t.integer "cc_exp"
    t.integer "zip"
    t.bigint "merchant_id"
    t.index ["merchant_id"], name: "index_orders_on_merchant_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "product_name"
    t.string "description"
    t.float "price"
    t.string "photo_url"
    t.bigint "stock"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "merchant_id"
    t.boolean "retired"
    t.index ["merchant_id"], name: "index_products_on_merchant_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "content"
    t.integer "rating", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_id"
    t.index ["product_id"], name: "index_reviews_on_product_id"
  end

  add_foreign_key "products", "merchants"
  add_foreign_key "reviews", "products"
end
