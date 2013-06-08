# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130608075356) do

  create_table "admins", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "advertiser_feeds", :force => true do |t|
    t.integer  "feed_version"
    t.datetime "feed_last_refresh"
    t.datetime "feed_last_modified"
    t.integer  "feed_product_count"
    t.integer  "advertiser_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "advertiser_feeds", ["advertiser_id"], :name => "index_advertiser_feeds_on_advertiser_id"

  create_table "advertisers", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "logo"
    t.boolean  "active"
    t.boolean  "enabled"
    t.integer  "metadata_version"
    t.string   "strapline"
    t.text     "description"
    t.string   "click_through"
    t.integer  "category_id"
    t.string   "url"
    t.integer  "country_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "products_count"
    t.string   "promote_url"
  end

  add_index "advertisers", ["category_id"], :name => "index_advertisers_on_category_id"
  add_index "advertisers", ["country_id"], :name => "index_advertisers_on_country_id"
  add_index "advertisers", ["slug"], :name => "index_advertisers_on_slug", :unique => true

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "products_count"
  end

  add_index "brands", ["slug"], :name => "index_brands_on_slug", :unique => true

  create_table "categories", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "slug"
    t.string   "name"
    t.integer  "awid"
    t.boolean  "is_adult"
    t.text     "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "products_count"
  end

  add_index "categories", ["slug"], :name => "index_categories_on_slug", :unique => true

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "country_code"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "countries", ["slug"], :name => "index_countries_on_slug", :unique => true

  create_table "deals", :force => true do |t|
    t.integer  "advertiser_id"
    t.integer  "country_id"
    t.string   "code"
    t.string   "description"
    t.string   "url"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "date_added"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "deals", ["advertiser_id"], :name => "index_deals_on_advertiser_id"
  add_index "deals", ["country_id"], :name => "index_deals_on_country_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "product_display_logs", :force => true do |t|
    t.integer  "product_id"
    t.string   "user_agent"
    t.string   "ip"
    t.text     "referrer"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "product_display_logs", ["product_id"], :name => "index_product_display_logs_on_product_id"

  create_table "product_visit_logs", :force => true do |t|
    t.integer  "product_id"
    t.string   "user_agent"
    t.string   "ip"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "product_visit_logs", ["product_id"], :name => "index_product_visit_logs_on_product_id"

  create_table "products", :force => true do |t|
    t.integer  "advertiser_id"
    t.integer  "category_id"
    t.integer  "aw_product_id"
    t.integer  "merchant_product_id"
    t.string   "name"
    t.string   "slug"
    t.string   "description"
    t.text     "aw_deep_link"
    t.string   "aw_image_url"
    t.string   "aw_thumb_url"
    t.float    "search_price"
    t.string   "currency"
    t.float    "delivery_cost"
    t.datetime "valid_to"
    t.datetime "valid_from"
    t.integer  "stock_quantity"
    t.string   "model_number"
    t.integer  "brand_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.float    "display_price"
    t.float    "store_price"
    t.string   "merchant_category"
    t.string   "merchant_deep_link"
    t.string   "merchant_image_url"
    t.string   "commission_group"
    t.string   "condition"
    t.string   "delivery_time"
    t.string   "ean"
    t.string   "in_stock"
    t.string   "isbn"
    t.string   "is_for_sale"
    t.string   "language"
    t.string   "merchant_thumb_url"
    t.string   "mpn"
    t.string   "pre_order"
    t.string   "product_type"
    t.string   "promotional_text"
    t.string   "upc"
    t.text     "warranty"
    t.integer  "parent_product_id"
    t.float    "rrp_price"
    t.string   "web_offer"
    t.text     "specifications"
  end

  add_index "products", ["advertiser_id"], :name => "index_products_on_advertiser_id"
  add_index "products", ["aw_product_id"], :name => "index_products_on_aw_product_id"
  add_index "products", ["brand_id"], :name => "index_products_on_brand_id"
  add_index "products", ["category_id"], :name => "index_products_on_category_id"
  add_index "products", ["slug"], :name => "index_products_on_slug", :unique => true

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "random_advertiser_products", :force => true do |t|
    t.integer  "advertiser_id"
    t.integer  "product_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "random_advertiser_products", ["advertiser_id"], :name => "index_random_advertiser_products_on_advertiser_id"
  add_index "random_advertiser_products", ["product_id"], :name => "index_random_advertiser_products_on_product_id"

  create_table "random_brand_products", :force => true do |t|
    t.integer  "brand_id"
    t.integer  "product_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "random_brand_products", ["brand_id"], :name => "index_random_brand_products_on_brand_id"
  add_index "random_brand_products", ["product_id"], :name => "index_random_brand_products_on_product_id"

  create_table "random_category_products", :force => true do |t|
    t.integer  "category_id"
    t.integer  "product_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "random_category_products", ["category_id"], :name => "index_random_category_products_on_category_id"
  add_index "random_category_products", ["product_id"], :name => "index_random_category_products_on_product_id"

  create_table "system_exceptions", :force => true do |t|
    t.text     "backtrace"
    t.text     "params"
    t.string   "message"
    t.integer  "exception_count"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "uri"
    t.string   "status_code"
  end

end
