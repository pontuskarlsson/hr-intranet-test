class RemoveStoreTables < ActiveRecord::Migration
  def up
    drop_table "refinery_store_order_items"
    drop_table "refinery_store_orders"
    drop_table "refinery_store_products"
    drop_table "refinery_store_retailers"
  end

  def down
    create_table "refinery_store_order_items", force: :cascade do |t|
      t.integer  "order_id",        limit: 4
      t.integer  "product_id",      limit: 4
      t.string   "product_number",  limit: 255
      t.decimal  "quantity",                    precision: 10, scale: 2, default: 0.0, null: false
      t.decimal  "price_per_item",              precision: 10, scale: 2, default: 0.0, null: false
      t.decimal  "sub_total_price",             precision: 10, scale: 2, default: 0.0, null: false
      t.string   "comment",         limit: 255
      t.integer  "position",        limit: 4
      t.datetime "created_at",                                                         null: false
      t.datetime "updated_at",                                                         null: false
    end

    add_index "refinery_store_order_items", ["order_id"], name: "index_refinery_store_order_items_on_order_id", using: :btree
    add_index "refinery_store_order_items", ["position"], name: "index_refinery_store_order_items_on_position", using: :btree
    add_index "refinery_store_order_items", ["product_id"], name: "index_refinery_store_order_items_on_product_id", using: :btree
    add_index "refinery_store_order_items", ["product_number"], name: "index_refinery_store_order_items_on_product_number", using: :btree

    create_table "refinery_store_orders", force: :cascade do |t|
      t.integer  "retailer_id",  limit: 4
      t.string   "order_number", limit: 255
      t.string   "reference",    limit: 255
      t.decimal  "total_price",              precision: 10, scale: 2, default: 0.0, null: false
      t.string   "price_unit",   limit: 255
      t.integer  "user_id",      limit: 4
      t.string   "status",       limit: 255
      t.integer  "position",     limit: 4
      t.datetime "created_at",                                                      null: false
      t.datetime "updated_at",                                                      null: false
    end

    add_index "refinery_store_orders", ["order_number"], name: "index_refinery_store_orders_on_order_number", using: :btree
    add_index "refinery_store_orders", ["position"], name: "index_refinery_store_orders_on_position", using: :btree
    add_index "refinery_store_orders", ["retailer_id"], name: "index_refinery_store_orders_on_retailer_id", using: :btree
    add_index "refinery_store_orders", ["status"], name: "index_refinery_store_orders_on_status", using: :btree
    add_index "refinery_store_orders", ["user_id"], name: "index_refinery_store_orders_on_user_id", using: :btree

    create_table "refinery_store_products", force: :cascade do |t|
      t.integer  "retailer_id",      limit: 4
      t.string   "product_number",   limit: 255
      t.string   "name",             limit: 255
      t.text     "description",      limit: 65535
      t.string   "measurement_unit", limit: 255
      t.decimal  "price_amount",                   precision: 10, scale: 2, default: 0.0, null: false
      t.string   "price_unit",       limit: 255
      t.integer  "image_id",         limit: 4
      t.date     "featured_at"
      t.date     "expired_at"
      t.integer  "position",         limit: 4
      t.datetime "created_at",                                                            null: false
      t.datetime "updated_at",                                                            null: false
    end

    add_index "refinery_store_products", ["expired_at"], name: "index_refinery_store_products_on_expired_at", using: :btree
    add_index "refinery_store_products", ["featured_at"], name: "index_refinery_store_products_on_featured_at", using: :btree
    add_index "refinery_store_products", ["image_id"], name: "index_refinery_store_products_on_image_id", using: :btree
    add_index "refinery_store_products", ["position"], name: "index_refinery_store_products_on_position", using: :btree
    add_index "refinery_store_products", ["product_number"], name: "index_refinery_store_products_on_product_number", using: :btree
    add_index "refinery_store_products", ["retailer_id"], name: "index_refinery_store_products_on_retailer_id", using: :btree

    create_table "refinery_store_retailers", force: :cascade do |t|
      t.string   "name",               limit: 255
      t.string   "default_price_unit", limit: 255
      t.integer  "position",           limit: 4
      t.date     "expired_at"
      t.datetime "created_at",                     null: false
      t.datetime "updated_at",                     null: false
    end

    add_index "refinery_store_retailers", ["expired_at"], name: "index_refinery_store_retailers_on_expired_at", using: :btree
    add_index "refinery_store_retailers", ["name"], name: "index_refinery_store_retailers_on_name", using: :btree
    add_index "refinery_store_retailers", ["position"], name: "index_refinery_store_retailers_on_position", using: :btree
  end
end
