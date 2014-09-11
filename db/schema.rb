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

ActiveRecord::Schema.define(:version => 20140911043135) do

  create_table "accounts", :force => true do |t|
    t.string   "guid",       :default => "", :null => false
    t.string   "code",       :default => "", :null => false
    t.string   "name",       :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "accounts", ["code"], :name => "index_accounts_on_code"
  add_index "accounts", ["guid"], :name => "index_accounts_on_guid"

  create_table "contacts", :force => true do |t|
    t.string   "guid",       :default => "", :null => false
    t.string   "name",       :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "contacts", ["guid"], :name => "index_contacts_on_guid"
  add_index "contacts", ["name"], :name => "index_contacts_on_name"

  create_table "expense_claims", :force => true do |t|
    t.integer  "user_id",                                                                      :null => false
    t.string   "guid",                                            :default => "",              :null => false
    t.string   "status",                                          :default => "Not-Submitted", :null => false
    t.string   "description",                                     :default => "",              :null => false
    t.decimal  "total",            :precision => 10, :scale => 0, :default => 0,               :null => false
    t.decimal  "amount_due",       :precision => 10, :scale => 0, :default => 0,               :null => false
    t.decimal  "amount_paid",      :precision => 10, :scale => 0, :default => 0,               :null => false
    t.date     "payment_due_date"
    t.datetime "updated_date"
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
  end

  add_index "expense_claims", ["guid"], :name => "index_expense_claims_on_guid"
  add_index "expense_claims", ["status"], :name => "index_expense_claims_on_status"
  add_index "expense_claims", ["user_id"], :name => "index_expense_claims_on_user_id"

  create_table "leaves", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "event_id"
    t.datetime "starts_at",                     :null => false
    t.datetime "ends_at",                       :null => false
    t.string   "comment",    :default => "",    :null => false
    t.boolean  "approved",   :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "leaves", ["approved"], :name => "index_leaves_on_approved"
  add_index "leaves", ["ends_at"], :name => "index_leaves_on_ends_at"
  add_index "leaves", ["event_id"], :name => "index_leaves_on_event_id"
  add_index "leaves", ["starts_at"], :name => "index_leaves_on_starts_at"
  add_index "leaves", ["user_id"], :name => "index_leaves_on_user_id"

  create_table "line_items", :force => true do |t|
    t.integer  "receipt_id",                                                   :null => false
    t.integer  "account_id",                                                   :null => false
    t.string   "description",                                  :default => "", :null => false
    t.string   "item_code",                                    :default => "", :null => false
    t.decimal  "quantity",      :precision => 10, :scale => 0, :default => 0,  :null => false
    t.decimal  "unit_amount",   :precision => 10, :scale => 0, :default => 0,  :null => false
    t.string   "tax_type",                                     :default => "", :null => false
    t.decimal  "tax_amount",    :precision => 10, :scale => 0, :default => 0,  :null => false
    t.decimal  "line_amount",   :precision => 10, :scale => 0, :default => 0,  :null => false
    t.decimal  "discount_rate", :precision => 10, :scale => 0, :default => 0,  :null => false
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  add_index "line_items", ["account_id"], :name => "index_line_items_on_account_id"
  add_index "line_items", ["receipt_id"], :name => "index_line_items_on_receipt_id"

  create_table "receipts", :force => true do |t|
    t.integer  "expense_claim_id",                                                              :null => false
    t.integer  "contact_id",                                                                    :null => false
    t.string   "guid",                                             :default => "",              :null => false
    t.string   "reference",                                        :default => "",              :null => false
    t.string   "status",                                           :default => "Not-Submitted", :null => false
    t.string   "line_amount_types",                                :default => "",              :null => false
    t.decimal  "sub_total",         :precision => 10, :scale => 0, :default => 0,               :null => false
    t.decimal  "total",             :precision => 10, :scale => 0, :default => 0,               :null => false
    t.date     "date"
    t.integer  "user_id",                                                                       :null => false
    t.datetime "created_at",                                                                    :null => false
    t.datetime "updated_at",                                                                    :null => false
  end

  add_index "receipts", ["contact_id"], :name => "index_receipts_on_contact_id"
  add_index "receipts", ["expense_claim_id"], :name => "index_receipts_on_expense_claim_id"
  add_index "receipts", ["guid"], :name => "index_receipts_on_guid"
  add_index "receipts", ["status"], :name => "index_receipts_on_status"
  add_index "receipts", ["user_id"], :name => "index_receipts_on_user_id"

  create_table "refinery_blog_categories", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "slug"
  end

  add_index "refinery_blog_categories", ["id"], :name => "index_refinery_blog_categories_on_id"
  add_index "refinery_blog_categories", ["slug"], :name => "index_refinery_blog_categories_on_slug"

  create_table "refinery_blog_categories_blog_posts", :force => true do |t|
    t.integer "blog_category_id"
    t.integer "blog_post_id"
  end

  add_index "refinery_blog_categories_blog_posts", ["blog_category_id", "blog_post_id"], :name => "index_blog_categories_blog_posts_on_bc_and_bp"

  create_table "refinery_blog_category_translations", :force => true do |t|
    t.integer  "refinery_blog_category_id"
    t.string   "locale",                    :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "title"
    t.string   "slug"
  end

  add_index "refinery_blog_category_translations", ["locale"], :name => "index_refinery_blog_category_translations_on_locale"
  add_index "refinery_blog_category_translations", ["refinery_blog_category_id"], :name => "index_a0315945e6213bbe0610724da0ee2de681b77c31"

  create_table "refinery_blog_comments", :force => true do |t|
    t.integer  "blog_post_id"
    t.boolean  "spam"
    t.string   "name"
    t.string   "email"
    t.text     "body"
    t.string   "state"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "refinery_blog_comments", ["blog_post_id"], :name => "index_refinery_blog_comments_on_blog_post_id"
  add_index "refinery_blog_comments", ["id"], :name => "index_refinery_blog_comments_on_id"

  create_table "refinery_blog_post_translations", :force => true do |t|
    t.integer  "refinery_blog_post_id"
    t.string   "locale",                :null => false
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.text     "body"
    t.text     "custom_teaser"
    t.string   "custom_url"
    t.string   "slug"
    t.string   "title"
  end

  add_index "refinery_blog_post_translations", ["locale"], :name => "index_refinery_blog_post_translations_on_locale"
  add_index "refinery_blog_post_translations", ["refinery_blog_post_id"], :name => "index_refinery_blog_post_translations_on_refinery_blog_post_id"

  create_table "refinery_blog_posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "draft"
    t.datetime "published_at"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "user_id"
    t.string   "custom_url"
    t.text     "custom_teaser"
    t.string   "source_url"
    t.string   "source_url_title"
    t.integer  "access_count",     :default => 0
    t.string   "slug"
  end

  add_index "refinery_blog_posts", ["access_count"], :name => "index_refinery_blog_posts_on_access_count"
  add_index "refinery_blog_posts", ["id"], :name => "index_refinery_blog_posts_on_id"
  add_index "refinery_blog_posts", ["slug"], :name => "index_refinery_blog_posts_on_slug"

  create_table "refinery_calendar_events", :force => true do |t|
    t.string   "title"
    t.string   "registration_link"
    t.string   "excerpt"
    t.text     "description"
    t.integer  "position"
    t.boolean  "featured"
    t.string   "slug"
    t.integer  "venue_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.datetime "starts_at"
    t.datetime "ends_at"
  end

  create_table "refinery_calendar_venues", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "url"
    t.string   "phone"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "refinery_image_page_translations", :force => true do |t|
    t.integer  "refinery_image_page_id"
    t.string   "locale",                 :null => false
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.text     "caption"
  end

  add_index "refinery_image_page_translations", ["locale"], :name => "index_refinery_image_page_translations_on_locale"
  add_index "refinery_image_page_translations", ["refinery_image_page_id"], :name => "index_186c9a170a0ab319c675aa80880ce155d8f47244"

  create_table "refinery_image_pages", :force => true do |t|
    t.integer "image_id"
    t.integer "page_id"
    t.integer "position"
    t.text    "caption"
    t.string  "page_type", :default => "page"
  end

  add_index "refinery_image_pages", ["image_id"], :name => "index_refinery_image_pages_on_image_id"
  add_index "refinery_image_pages", ["page_id"], :name => "index_refinery_image_pages_on_page_id"

  create_table "refinery_images", :force => true do |t|
    t.string   "image_mime_type"
    t.string   "image_name"
    t.integer  "image_size"
    t.integer  "image_width"
    t.integer  "image_height"
    t.string   "image_uid"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "refinery_news_item_translations", :force => true do |t|
    t.integer  "refinery_news_item_id"
    t.string   "locale",                :null => false
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "title"
    t.text     "body"
    t.string   "source"
    t.string   "slug"
  end

  add_index "refinery_news_item_translations", ["locale"], :name => "index_refinery_news_item_translations_on_locale"
  add_index "refinery_news_item_translations", ["refinery_news_item_id"], :name => "index_refinery_news_item_translations_fk"

  create_table "refinery_news_items", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "publish_date"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "image_id"
    t.datetime "expiration_date"
    t.string   "source"
    t.string   "slug"
  end

  add_index "refinery_news_items", ["id"], :name => "index_refinery_news_items_on_id"

  create_table "refinery_page_part_translations", :force => true do |t|
    t.integer  "refinery_page_part_id"
    t.string   "locale",                :null => false
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.text     "body"
  end

  add_index "refinery_page_part_translations", ["locale"], :name => "index_refinery_page_part_translations_on_locale"
  add_index "refinery_page_part_translations", ["refinery_page_part_id"], :name => "index_refinery_page_part_translations_on_refinery_page_part_id"

  create_table "refinery_page_parts", :force => true do |t|
    t.integer  "refinery_page_id"
    t.string   "title"
    t.text     "body"
    t.integer  "position"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "refinery_page_parts", ["id"], :name => "index_refinery_page_parts_on_id"
  add_index "refinery_page_parts", ["refinery_page_id"], :name => "index_refinery_page_parts_on_refinery_page_id"

  create_table "refinery_page_translations", :force => true do |t|
    t.integer  "refinery_page_id"
    t.string   "locale",           :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "title"
    t.string   "custom_slug"
    t.string   "menu_title"
    t.string   "slug"
  end

  add_index "refinery_page_translations", ["locale"], :name => "index_refinery_page_translations_on_locale"
  add_index "refinery_page_translations", ["refinery_page_id"], :name => "index_refinery_page_translations_on_refinery_page_id"

  create_table "refinery_pages", :force => true do |t|
    t.integer  "parent_id"
    t.string   "path"
    t.string   "slug"
    t.boolean  "show_in_menu",        :default => true
    t.string   "link_url"
    t.string   "menu_match"
    t.boolean  "deletable",           :default => true
    t.boolean  "draft",               :default => false
    t.boolean  "skip_to_first_child", :default => false
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "view_template"
    t.string   "layout_template"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "refinery_pages", ["depth"], :name => "index_refinery_pages_on_depth"
  add_index "refinery_pages", ["id"], :name => "index_refinery_pages_on_id"
  add_index "refinery_pages", ["lft"], :name => "index_refinery_pages_on_lft"
  add_index "refinery_pages", ["parent_id"], :name => "index_refinery_pages_on_parent_id"
  add_index "refinery_pages", ["rgt"], :name => "index_refinery_pages_on_rgt"

  create_table "refinery_resources", :force => true do |t|
    t.string   "file_mime_type"
    t.string   "file_name"
    t.integer  "file_size"
    t.string   "file_uid"
    t.string   "file_ext"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "refinery_roles", :force => true do |t|
    t.string "title"
  end

  create_table "refinery_roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "refinery_roles_users", ["role_id", "user_id"], :name => "index_refinery_roles_users_on_role_id_and_user_id"
  add_index "refinery_roles_users", ["user_id", "role_id"], :name => "index_refinery_roles_users_on_user_id_and_role_id"

  create_table "refinery_settings", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.boolean  "destroyable",     :default => true
    t.string   "scoping"
    t.boolean  "restricted",      :default => false
    t.string   "form_value_type"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "slug"
  end

  add_index "refinery_settings", ["name"], :name => "index_refinery_settings_on_name"

  create_table "refinery_user_plugins", :force => true do |t|
    t.integer "user_id"
    t.string  "name"
    t.integer "position"
  end

  add_index "refinery_user_plugins", ["name"], :name => "index_refinery_user_plugins_on_name"
  add_index "refinery_user_plugins", ["user_id", "name"], :name => "index_refinery_user_plugins_on_user_id_and_name", :unique => true

  create_table "refinery_users", :force => true do |t|
    t.string   "username",                               :null => false
    t.string   "email",                                  :null => false
    t.string   "encrypted_password",                     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "sign_in_count"
    t.datetime "remember_created_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "slug"
    t.string   "title"
    t.string   "full_name"
    t.integer  "profile_image_id"
    t.string   "xero_guid",              :default => "", :null => false
  end

  add_index "refinery_users", ["id"], :name => "index_refinery_users_on_id"
  add_index "refinery_users", ["profile_image_id"], :name => "index_refinery_users_on_profile_image_id"
  add_index "refinery_users", ["slug"], :name => "index_refinery_users_on_slug"

  create_table "seo_meta", :force => true do |t|
    t.integer  "seo_meta_id"
    t.string   "seo_meta_type"
    t.string   "browser_title"
    t.text     "meta_description"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "seo_meta", ["id"], :name => "index_seo_meta_on_id"
  add_index "seo_meta", ["seo_meta_id", "seo_meta_type"], :name => "id_type_index_on_seo_meta"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

end
