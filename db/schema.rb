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

ActiveRecord::Schema.define(:version => 20180418032515) do

  create_table "amqp_messages", :force => true do |t|
    t.string   "queue",       :null => false
    t.text     "message",     :null => false
    t.text     "type",        :null => false
    t.integer  "sender_id"
    t.string   "sender_type"
    t.datetime "sent_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "amqp_messages", ["sender_id", "sender_type"], :name => "index_amqp_messages_on_sender_id_and_sender_type"
  add_index "amqp_messages", ["sent_at"], :name => "index_amqp_messages_on_sent_at"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "refinery_amqp_messages", :force => true do |t|
    t.string   "queue",       :null => false
    t.text     "message",     :null => false
    t.text     "type",        :null => false
    t.integer  "sender_id"
    t.string   "sender_type"
    t.datetime "sent_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "refinery_amqp_messages", ["sender_id", "sender_type"], :name => "index_refinery_amqp_messages_on_sender_id_and_sender_type"
  add_index "refinery_amqp_messages", ["sent_at"], :name => "index_refinery_amqp_messages_on_sent_at"

  create_table "refinery_annual_leave_records", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "annual_leave_id"
    t.string   "record_type"
    t.date     "record_date"
    t.decimal  "record_value",    :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
  end

  add_index "refinery_annual_leave_records", ["annual_leave_id"], :name => "index_refinery_annual_leave_records_on_annual_leave_id"
  add_index "refinery_annual_leave_records", ["employee_id"], :name => "index_refinery_annual_leave_records_on_employee_id"
  add_index "refinery_annual_leave_records", ["record_date"], :name => "index_refinery_annual_leave_records_on_record_date"
  add_index "refinery_annual_leave_records", ["record_type"], :name => "index_refinery_annual_leave_records_on_record_type"

  create_table "refinery_annual_leaves", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "event_id"
    t.date     "start_date"
    t.boolean  "start_half_day",                                :default => false, :null => false
    t.date     "end_date"
    t.boolean  "end_half_day",                                  :default => false, :null => false
    t.decimal  "number_of_days", :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  add_index "refinery_annual_leaves", ["employee_id"], :name => "index_refinery_annual_leaves_on_employee_id"
  add_index "refinery_annual_leaves", ["end_date"], :name => "index_refinery_annual_leaves_on_end_date"
  add_index "refinery_annual_leaves", ["event_id"], :name => "index_refinery_annual_leaves_on_event_id"
  add_index "refinery_annual_leaves", ["start_date"], :name => "index_refinery_annual_leaves_on_start_date"

  create_table "refinery_blog_categories", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "cached_slug"
  end

  add_index "refinery_blog_categories", ["id"], :name => "index_refinery_blog_categories_on_id"

  create_table "refinery_blog_categories_blog_posts", :force => true do |t|
    t.integer "blog_category_id"
    t.integer "blog_post_id"
  end

  add_index "refinery_blog_categories_blog_posts", ["blog_category_id", "blog_post_id"], :name => "index_blog_categories_blog_posts_on_bc_and_bp"

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

  create_table "refinery_blog_posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "draft"
    t.datetime "published_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "user_id"
    t.string   "cached_slug"
    t.string   "custom_url"
    t.text     "custom_teaser"
  end

  add_index "refinery_blog_posts", ["id"], :name => "index_refinery_blog_posts_on_id"

  create_table "refinery_brand_shows", :force => true do |t|
    t.integer  "brand_id"
    t.integer  "show_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "refinery_brand_shows", ["brand_id"], :name => "index_refinery_brand_shows_on_brand_id"
  add_index "refinery_brand_shows", ["show_id"], :name => "index_refinery_brand_shows_on_show_id"

  create_table "refinery_brands", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.integer  "logo_id"
    t.text     "description"
    t.integer  "position"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "refinery_business_budget_items", :force => true do |t|
    t.integer  "budget_id"
    t.string   "description"
    t.integer  "no_of_products",                               :default => 0,   :null => false
    t.integer  "no_of_skus",                                   :default => 0,   :null => false
    t.decimal  "price",          :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.integer  "quantity",                                     :default => 0,   :null => false
    t.decimal  "margin",         :precision => 6, :scale => 5, :default => 0.0, :null => false
    t.text     "comments",                                                      :null => false
    t.integer  "position"
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
  end

  add_index "refinery_business_budget_items", ["budget_id"], :name => "index_refinery_business_budget_items_on_budget_id"

  create_table "refinery_business_budgets", :force => true do |t|
    t.string   "description",                                           :default => "",  :null => false
    t.string   "customer_name",                                         :default => "",  :null => false
    t.integer  "customer_contact_id"
    t.date     "from_date"
    t.date     "to_date"
    t.string   "account_manager_name",                                  :default => "",  :null => false
    t.integer  "account_manager_user_id"
    t.integer  "no_of_products",                                        :default => 0,   :null => false
    t.integer  "no_of_skus",                                            :default => 0,   :null => false
    t.decimal  "price",                   :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.integer  "quantity",                                              :default => 0,   :null => false
    t.decimal  "margin",                  :precision => 6, :scale => 5, :default => 0.0, :null => false
    t.text     "comments"
    t.integer  "position"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
    t.decimal  "total",                   :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "margin_total",            :precision => 8, :scale => 2, :default => 0.0, :null => false
  end

  add_index "refinery_business_budgets", ["account_manager_user_id"], :name => "index_refinery_business_budgets_on_account_manager_user_id"
  add_index "refinery_business_budgets", ["customer_contact_id"], :name => "index_refinery_business_budgets_on_customer_contact_id"
  add_index "refinery_business_budgets", ["description"], :name => "index_refinery_business_budgets_on_description"

  create_table "refinery_calendar_calendars", :force => true do |t|
    t.string   "title"
    t.string   "function"
    t.integer  "user_id"
    t.boolean  "private",          :default => false, :null => false
    t.string   "default_rgb_code"
    t.integer  "position"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "refinery_calendar_calendars", ["function"], :name => "index_refinery_calendar_calendars_on_function"
  add_index "refinery_calendar_calendars", ["position"], :name => "index_refinery_calendar_calendars_on_position"
  add_index "refinery_calendar_calendars", ["private"], :name => "index_refinery_calendar_calendars_on_private"
  add_index "refinery_calendar_calendars", ["user_id"], :name => "index_refinery_calendar_calendars_on_user_id"

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
    t.integer  "calendar_id"
  end

  add_index "refinery_calendar_events", ["calendar_id"], :name => "index_refinery_calendar_events_on_calendar_id"

  create_table "refinery_calendar_google_calendars", :force => true do |t|
    t.integer  "user_id"
    t.integer  "primary_calendar_id"
    t.string   "google_calendar_id"
    t.string   "refresh_token"
    t.integer  "sync_to_id",          :default => 0, :null => false
    t.integer  "sync_from_id",        :default => 0, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "refinery_calendar_google_calendars", ["google_calendar_id"], :name => "index_rcgc_on_google_calendar_id"
  add_index "refinery_calendar_google_calendars", ["primary_calendar_id"], :name => "index_rcgc_on_primary_calendar_id"
  add_index "refinery_calendar_google_calendars", ["user_id"], :name => "index_rcgc_on_user_id"

  create_table "refinery_calendar_google_events", :force => true do |t|
    t.integer  "google_calendar_id"
    t.integer  "event_id"
    t.string   "google_event_id"
    t.datetime "last_synced_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "refinery_calendar_google_events", ["event_id"], :name => "index_rcge_on_event_id"
  add_index "refinery_calendar_google_events", ["google_calendar_id"], :name => "index_rcge_on_google_calendar_id"
  add_index "refinery_calendar_google_events", ["google_event_id"], :name => "index_rcge_on_google_event_id"

  create_table "refinery_calendar_user_calendars", :force => true do |t|
    t.integer  "user_id"
    t.integer  "calendar_id"
    t.boolean  "inactive",    :default => false, :null => false
    t.string   "rgb_code"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "refinery_calendar_user_calendars", ["calendar_id"], :name => "index_refinery_calendar_user_calendars_on_calendar_id"
  add_index "refinery_calendar_user_calendars", ["inactive"], :name => "index_refinery_calendar_user_calendars_on_inactive"
  add_index "refinery_calendar_user_calendars", ["user_id"], :name => "index_refinery_calendar_user_calendars_on_user_id"

  create_table "refinery_calendar_venues", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "url"
    t.string   "phone"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "refinery_contacts", :force => true do |t|
    t.integer  "base_id"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "city"
    t.string   "skype"
    t.string   "zip"
    t.string   "country"
    t.string   "title"
    t.boolean  "private"
    t.integer  "contact_id"
    t.boolean  "is_organisation"
    t.string   "mobile"
    t.string   "fax"
    t.string   "website"
    t.string   "phone"
    t.string   "description"
    t.string   "linked_in"
    t.string   "facebook"
    t.string   "industry"
    t.string   "twitter"
    t.string   "email"
    t.string   "organisation_name"
    t.integer  "organisation_id"
    t.string   "tags_joined_by_comma"
    t.boolean  "is_sales_account"
    t.string   "customer_status"
    t.string   "prospect_status"
    t.datetime "base_modified_at"
    t.text     "custom_fields"
    t.integer  "position"
    t.boolean  "removed_from_base",    :default => false, :null => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "user_id"
    t.string   "state"
    t.integer  "insightly_id"
    t.string   "courier_company"
    t.string   "courier_account_no"
    t.string   "image_url"
    t.string   "code"
  end

  add_index "refinery_contacts", ["base_id"], :name => "index_refinery_contacts_on_base_id"
  add_index "refinery_contacts", ["base_modified_at"], :name => "index_refinery_contacts_on_base_modified_at"
  add_index "refinery_contacts", ["code"], :name => "index_refinery_contacts_on_code"
  add_index "refinery_contacts", ["courier_company"], :name => "index_refinery_contacts_on_courier_company"
  add_index "refinery_contacts", ["insightly_id"], :name => "index_refinery_contacts_on_insightly_id"
  add_index "refinery_contacts", ["organisation_id"], :name => "index_refinery_contacts_on_organisation_id"
  add_index "refinery_contacts", ["removed_from_base"], :name => "index_refinery_contacts_on_removed_from_base"
  add_index "refinery_contacts", ["state"], :name => "index_refinery_contacts_on_state"
  add_index "refinery_contacts", ["user_id"], :name => "index_refinery_contacts_on_user_id"

  create_table "refinery_custom_lists_custom_lists", :force => true do |t|
    t.string   "title"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "refinery_custom_lists_list_cells", :force => true do |t|
    t.integer  "list_row_id"
    t.integer  "list_column_id"
    t.string   "value"
    t.integer  "position"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "refinery_custom_lists_list_cells", ["list_column_id"], :name => "index_refinery_custom_lists_list_cells_on_list_column_id"
  add_index "refinery_custom_lists_list_cells", ["list_row_id"], :name => "index_refinery_custom_lists_list_cells_on_list_row_id"
  add_index "refinery_custom_lists_list_cells", ["value"], :name => "index_refinery_custom_lists_list_cells_on_value"

  create_table "refinery_custom_lists_list_columns", :force => true do |t|
    t.integer  "custom_list_id"
    t.string   "title"
    t.string   "column_type"
    t.integer  "position"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "refinery_custom_lists_list_columns", ["custom_list_id"], :name => "index_refinery_custom_lists_list_columns_on_custom_list_id"
  add_index "refinery_custom_lists_list_columns", ["position"], :name => "index_refinery_custom_lists_list_columns_on_position"

  create_table "refinery_custom_lists_list_rows", :force => true do |t|
    t.integer  "custom_list_id"
    t.integer  "position"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "refinery_custom_lists_list_rows", ["custom_list_id"], :name => "index_refinery_custom_lists_list_rows_on_custom_list_id"
  add_index "refinery_custom_lists_list_rows", ["position"], :name => "index_refinery_custom_lists_list_rows_on_position"

  create_table "refinery_employees", :force => true do |t|
    t.integer  "user_id"
    t.integer  "profile_image_id"
    t.string   "employee_no"
    t.string   "full_name"
    t.string   "id_no"
    t.string   "title"
    t.integer  "position"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "xero_guid"
    t.text     "default_tracking_options"
    t.integer  "reporting_manager_id"
    t.integer  "contact_id"
    t.string   "emergency_contact"
    t.date     "birthday"
  end

  add_index "refinery_employees", ["birthday"], :name => "index_refinery_employees_on_birthday"
  add_index "refinery_employees", ["contact_id"], :name => "index_refinery_employees_on_contact_id"
  add_index "refinery_employees", ["employee_no"], :name => "index_refinery_employees_on_employee_no"
  add_index "refinery_employees", ["position"], :name => "index_refinery_employees_on_position"
  add_index "refinery_employees", ["profile_image_id"], :name => "index_refinery_employees_on_profile_image_id"
  add_index "refinery_employees", ["reporting_manager_id"], :name => "index_refinery_employees_on_reporting_manager_id"
  add_index "refinery_employees", ["user_id"], :name => "index_refinery_employees_on_user_id"

  create_table "refinery_employment_contracts", :force => true do |t|
    t.integer  "employee_id",                                                            :null => false
    t.date     "start_date",                                                             :null => false
    t.date     "end_date"
    t.decimal  "vacation_days_per_year", :precision => 10, :scale => 0, :default => 0,   :null => false
    t.decimal  "days_carried_over",      :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.string   "country"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
  end

  add_index "refinery_employment_contracts", ["employee_id"], :name => "index_refinery_employment_contracts_on_employee_id"
  add_index "refinery_employment_contracts", ["end_date"], :name => "index_refinery_employment_contracts_on_end_date"
  add_index "refinery_employment_contracts", ["start_date"], :name => "index_refinery_employment_contracts_on_start_date"

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

  create_table "refinery_leave_of_absences", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "event_id"
    t.integer  "doctors_note_id"
    t.integer  "absence_type_id"
    t.string   "absence_type_description"
    t.integer  "status"
    t.date     "start_date"
    t.boolean  "start_half_day",           :default => false, :null => false
    t.date     "end_date"
    t.boolean  "end_half_day",             :default => false, :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "refinery_leave_of_absences", ["absence_type_id"], :name => "index_refinery_leave_of_absences_on_absence_type_id"
  add_index "refinery_leave_of_absences", ["doctors_note_id"], :name => "index_refinery_leave_of_absences_on_doctors_note_id"
  add_index "refinery_leave_of_absences", ["employee_id"], :name => "index_refinery_leave_of_absences_on_employee_id"
  add_index "refinery_leave_of_absences", ["end_date"], :name => "index_refinery_leave_of_absences_on_end_date"
  add_index "refinery_leave_of_absences", ["event_id"], :name => "index_refinery_leave_of_absences_on_event_id"
  add_index "refinery_leave_of_absences", ["start_date"], :name => "index_refinery_leave_of_absences_on_start_date"
  add_index "refinery_leave_of_absences", ["status"], :name => "index_refinery_leave_of_absences_on_status"

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

  create_table "refinery_order_items", :force => true do |t|
    t.integer  "sales_order_id",                                                              :null => false
    t.string   "order_detail_id",                                          :default => "",    :null => false
    t.string   "order_detail_imported_ref",                                :default => "",    :null => false
    t.string   "order_id",                                                 :default => "",    :null => false
    t.string   "order_ref",                                                :default => "",    :null => false
    t.datetime "created_date"
    t.boolean  "active",                                                   :default => false, :null => false
    t.string   "sku",                                                      :default => "",    :null => false
    t.string   "code",                                                     :default => "",    :null => false
    t.string   "product_id",                                               :default => "",    :null => false
    t.string   "style_code",                                               :default => "",    :null => false
    t.string   "master_id",                                                :default => "",    :null => false
    t.decimal  "price",                     :precision => 10, :scale => 0, :default => 0,     :null => false
    t.decimal  "qty",                       :precision => 10, :scale => 0, :default => 0,     :null => false
    t.string   "name",                                                     :default => "",    :null => false
    t.decimal  "discount",                  :precision => 10, :scale => 0, :default => 0,     :null => false
    t.string   "option1",                                                  :default => "",    :null => false
    t.string   "option2",                                                  :default => "",    :null => false
    t.string   "option3",                                                  :default => "",    :null => false
    t.string   "line_comments",                                            :default => "",    :null => false
    t.integer  "position"
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
  end

  add_index "refinery_order_items", ["active"], :name => "index_refinery_order_items_on_active"
  add_index "refinery_order_items", ["order_detail_id"], :name => "index_refinery_order_items_on_order_detail_id"
  add_index "refinery_order_items", ["order_id"], :name => "index_refinery_order_items_on_order_id"
  add_index "refinery_order_items", ["position"], :name => "index_refinery_order_items_on_position"
  add_index "refinery_order_items", ["sales_order_id"], :name => "index_refinery_order_items_on_sales_order_id"

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

  create_table "refinery_page_roles", :force => true do |t|
    t.integer  "page_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "refinery_page_roles", ["page_id", "role_id"], :name => "index_refinery_page_roles_on_page_id_and_role_id"

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

  create_table "refinery_parcels", :force => true do |t|
    t.date     "parcel_date"
    t.string   "from_name"
    t.integer  "from_contact_id"
    t.string   "courier"
    t.string   "air_waybill_no"
    t.string   "to_name"
    t.integer  "to_user_id"
    t.integer  "shipping_document_id"
    t.boolean  "receiver_signed",      :default => false, :null => false
    t.integer  "position"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "received_by_id"
    t.integer  "assigned_to_id"
    t.string   "description"
  end

  add_index "refinery_parcels", ["assigned_to_id"], :name => "index_refinery_parcels_on_assigned_to_id"
  add_index "refinery_parcels", ["from_contact_id"], :name => "index_refinery_parcels_on_from_contact_id"
  add_index "refinery_parcels", ["position"], :name => "index_refinery_parcels_on_position"
  add_index "refinery_parcels", ["received_by_id"], :name => "index_refinery_parcels_on_received_by_id"
  add_index "refinery_parcels", ["receiver_signed"], :name => "index_refinery_parcels_on_receiver_signed"
  add_index "refinery_parcels", ["shipping_document_id"], :name => "index_refinery_parcels_on_shipping_document_id"
  add_index "refinery_parcels", ["to_user_id"], :name => "index_refinery_parcels_on_to_user_id"

  create_table "refinery_parcels_shipment_accounts", :force => true do |t|
    t.integer  "contact_id"
    t.string   "description"
    t.string   "courier"
    t.string   "account_no"
    t.text     "comments"
    t.integer  "position"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "refinery_parcels_shipment_accounts", ["account_no"], :name => "index_refinery_parcels_shipment_accounts_on_account_no"
  add_index "refinery_parcels_shipment_accounts", ["contact_id"], :name => "index_refinery_parcels_shipment_accounts_on_contact_id"
  add_index "refinery_parcels_shipment_accounts", ["courier"], :name => "index_refinery_parcels_shipment_accounts_on_courier"
  add_index "refinery_parcels_shipment_accounts", ["position"], :name => "index_refinery_parcels_shipment_accounts_on_position"

  create_table "refinery_parcels_shipment_addresses", :force => true do |t|
    t.string   "easy_post_id"
    t.string   "name"
    t.string   "company"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "phone"
    t.string   "email"
    t.integer  "position"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "refinery_parcels_shipment_addresses", ["easy_post_id"], :name => "index_refinery_parcels_shipment_addresses_on_easy_post_id"
  add_index "refinery_parcels_shipment_addresses", ["position"], :name => "index_refinery_parcels_shipment_addresses_on_position"

  create_table "refinery_parcels_shipment_parcels", :force => true do |t|
    t.integer  "shipment_id"
    t.integer  "length"
    t.integer  "width"
    t.integer  "height"
    t.integer  "weight"
    t.string   "predefined_package"
    t.integer  "position"
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
    t.string   "description"
    t.integer  "quantity",                                         :default => 0, :null => false
    t.decimal  "value",              :precision => 8, :scale => 2
    t.string   "origin_country"
    t.string   "contents_type"
  end

  add_index "refinery_parcels_shipment_parcels", ["position"], :name => "index_refinery_parcels_shipment_parcels_on_position"

  create_table "refinery_parcels_shipments", :force => true do |t|
    t.integer  "from_contact_id"
    t.integer  "from_address_id"
    t.integer  "to_contact_id"
    t.integer  "to_address_id"
    t.integer  "created_by_id"
    t.integer  "assigned_to_id"
    t.string   "courier"
    t.integer  "position"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.integer  "bill_to_account_id"
    t.string   "bill_to"
    t.string   "description"
    t.string   "label_url"
    t.string   "tracking_number"
    t.string   "tracking_status"
    t.string   "status"
    t.string   "easypost_object_id"
    t.text     "rates_content"
    t.string   "rate_object_id"
    t.string   "rate_service"
    t.decimal  "rate_amount",        :precision => 8, :scale => 2
    t.string   "rate_currency"
    t.date     "shipping_date"
    t.text     "tracking_info"
  end

  add_index "refinery_parcels_shipments", ["assigned_to_id"], :name => "index_refinery_parcels_shipments_on_assigned_to_id"
  add_index "refinery_parcels_shipments", ["bill_to_account_id"], :name => "index_refinery_parcels_shipments_on_bta_id"
  add_index "refinery_parcels_shipments", ["created_by_id"], :name => "index_refinery_parcels_shipments_on_created_by_id"
  add_index "refinery_parcels_shipments", ["easypost_object_id"], :name => "index_refinery_parcels_shipments_on_eo_id"
  add_index "refinery_parcels_shipments", ["from_address_id"], :name => "index_refinery_parcels_shipments_on_from_address_id"
  add_index "refinery_parcels_shipments", ["from_contact_id"], :name => "index_refinery_parcels_shipments_on_from_contact_id"
  add_index "refinery_parcels_shipments", ["position"], :name => "index_refinery_parcels_shipments_on_position"
  add_index "refinery_parcels_shipments", ["status"], :name => "index_refinery_parcels_shipments_on_status"
  add_index "refinery_parcels_shipments", ["to_address_id"], :name => "index_refinery_parcels_shipments_on_to_address_id"
  add_index "refinery_parcels_shipments", ["to_contact_id"], :name => "index_refinery_parcels_shipments_on_to_contact_id"

  create_table "refinery_public_holidays", :force => true do |t|
    t.integer  "event_id"
    t.string   "title"
    t.string   "country"
    t.date     "holiday_date",                    :null => false
    t.boolean  "half_day",     :default => false, :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "refinery_public_holidays", ["event_id"], :name => "index_refinery_public_holidays_on_event_id"
  add_index "refinery_public_holidays", ["holiday_date"], :name => "index_refinery_public_holidays_on_holiday_date"

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

  create_table "refinery_sales_orders", :force => true do |t|
    t.string   "order_id",                                            :default => "",    :null => false
    t.string   "order_session_id",                                    :default => "",    :null => false
    t.string   "order_ref",                                           :default => "",    :null => false
    t.datetime "created_date"
    t.datetime "modified_date"
    t.boolean  "active",                                              :default => false, :null => false
    t.string   "transaction_type",                                    :default => "",    :null => false
    t.string   "member_id",                                           :default => "",    :null => false
    t.string   "member_email",                                        :default => "",    :null => false
    t.string   "member_cost_center",                                  :default => "",    :null => false
    t.string   "member_session_id",                                   :default => "",    :null => false
    t.string   "sales_person_id",                                     :default => "",    :null => false
    t.string   "sales_person_email",                                  :default => "",    :null => false
    t.decimal  "product_total",        :precision => 10, :scale => 0, :default => 0,     :null => false
    t.decimal  "freight_total",        :precision => 10, :scale => 0, :default => 0,     :null => false
    t.string   "freight_description",                                 :default => "",    :null => false
    t.decimal  "discount_total",       :precision => 10, :scale => 0, :default => 0,     :null => false
    t.string   "discount_description",                                :default => "",    :null => false
    t.decimal  "total",                :precision => 10, :scale => 0, :default => 0,     :null => false
    t.decimal  "currency_rate",        :precision => 10, :scale => 0, :default => 0,     :null => false
    t.string   "currency_name",                                       :default => "",    :null => false
    t.string   "currency_symbol",                                     :default => "",    :null => false
    t.string   "tax_status",                                          :default => "",    :null => false
    t.decimal  "tax_rate",             :precision => 10, :scale => 0, :default => 0,     :null => false
    t.string   "first_name",                                          :default => "",    :null => false
    t.string   "last_name",                                           :default => "",    :null => false
    t.string   "company",                                             :default => "",    :null => false
    t.string   "phone",                                               :default => "",    :null => false
    t.string   "mobile",                                              :default => "",    :null => false
    t.string   "email",                                               :default => "",    :null => false
    t.string   "delivery_first_name",                                 :default => "",    :null => false
    t.string   "delivery_last_name",                                  :default => "",    :null => false
    t.string   "delivery_company",                                    :default => "",    :null => false
    t.string   "delivery_address",                                    :default => "",    :null => false
    t.string   "delivery_suburb",                                     :default => "",    :null => false
    t.string   "delivery_city",                                       :default => "",    :null => false
    t.string   "delivery_postal_code",                                :default => "",    :null => false
    t.string   "delivery_state",                                      :default => "",    :null => false
    t.string   "delivery_country",                                    :default => "",    :null => false
    t.string   "billing_first_name",                                  :default => "",    :null => false
    t.string   "billing_last_name",                                   :default => "",    :null => false
    t.string   "billing_company",                                     :default => "",    :null => false
    t.string   "billing_address",                                     :default => "",    :null => false
    t.string   "billing_suburb",                                      :default => "",    :null => false
    t.string   "billing_city",                                        :default => "",    :null => false
    t.string   "billing_postal_code",                                 :default => "",    :null => false
    t.string   "billing_state",                                       :default => "",    :null => false
    t.string   "billing_country",                                     :default => "",    :null => false
    t.string   "comments",                                            :default => "",    :null => false
    t.string   "voucher_code",                                        :default => "",    :null => false
    t.string   "branch_id",                                           :default => "",    :null => false
    t.string   "branch_email",                                        :default => "",    :null => false
    t.string   "stage",                                               :default => "",    :null => false
    t.string   "cost_center",                                         :default => "",    :null => false
    t.string   "tracking_code",                                       :default => "",    :null => false
    t.string   "payment_terms",                                       :default => "",    :null => false
    t.integer  "position"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
  end

  add_index "refinery_sales_orders", ["active"], :name => "index_refinery_sales_orders_on_active"
  add_index "refinery_sales_orders", ["order_id"], :name => "index_refinery_sales_orders_on_order_id"
  add_index "refinery_sales_orders", ["position"], :name => "index_refinery_sales_orders_on_position"

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

  create_table "refinery_shows", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.integer  "logo_id"
    t.text     "description"
    t.text     "msg_json_struct"
    t.datetime "last_sync_datetime"
    t.string   "last_sync_result"
    t.integer  "position"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "refinery_sick_leaves", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "event_id"
    t.integer  "doctors_note_id"
    t.date     "start_date"
    t.boolean  "start_half_day",                                 :default => false, :null => false
    t.date     "end_date"
    t.boolean  "end_half_day",                                   :default => false, :null => false
    t.decimal  "number_of_days",  :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
  end

  add_index "refinery_sick_leaves", ["doctors_note_id"], :name => "index_refinery_sick_leaves_on_doctors_note_id"
  add_index "refinery_sick_leaves", ["employee_id"], :name => "index_refinery_sick_leaves_on_employee_id"
  add_index "refinery_sick_leaves", ["end_date"], :name => "index_refinery_sick_leaves_on_end_date"
  add_index "refinery_sick_leaves", ["event_id"], :name => "index_refinery_sick_leaves_on_event_id"
  add_index "refinery_sick_leaves", ["start_date"], :name => "index_refinery_sick_leaves_on_start_date"

  create_table "refinery_store_order_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.string   "product_number"
    t.decimal  "quantity",        :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal  "price_per_item",  :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal  "sub_total_price", :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.string   "comment"
    t.integer  "position"
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
  end

  add_index "refinery_store_order_items", ["order_id"], :name => "index_refinery_store_order_items_on_order_id"
  add_index "refinery_store_order_items", ["position"], :name => "index_refinery_store_order_items_on_position"
  add_index "refinery_store_order_items", ["product_id"], :name => "index_refinery_store_order_items_on_product_id"
  add_index "refinery_store_order_items", ["product_number"], :name => "index_refinery_store_order_items_on_product_number"

  create_table "refinery_store_orders", :force => true do |t|
    t.integer  "retailer_id"
    t.string   "order_number"
    t.string   "reference"
    t.decimal  "total_price",  :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.string   "price_unit"
    t.integer  "user_id"
    t.string   "status"
    t.integer  "position"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  add_index "refinery_store_orders", ["order_number"], :name => "index_refinery_store_orders_on_order_number"
  add_index "refinery_store_orders", ["position"], :name => "index_refinery_store_orders_on_position"
  add_index "refinery_store_orders", ["retailer_id"], :name => "index_refinery_store_orders_on_retailer_id"
  add_index "refinery_store_orders", ["status"], :name => "index_refinery_store_orders_on_status"
  add_index "refinery_store_orders", ["user_id"], :name => "index_refinery_store_orders_on_user_id"

  create_table "refinery_store_products", :force => true do |t|
    t.integer  "retailer_id"
    t.string   "product_number"
    t.string   "name"
    t.text     "description"
    t.string   "measurement_unit"
    t.decimal  "price_amount",     :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.string   "price_unit"
    t.integer  "image_id"
    t.date     "featured_at"
    t.date     "expired_at"
    t.integer  "position"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  add_index "refinery_store_products", ["expired_at"], :name => "index_refinery_store_products_on_expired_at"
  add_index "refinery_store_products", ["featured_at"], :name => "index_refinery_store_products_on_featured_at"
  add_index "refinery_store_products", ["image_id"], :name => "index_refinery_store_products_on_image_id"
  add_index "refinery_store_products", ["position"], :name => "index_refinery_store_products_on_position"
  add_index "refinery_store_products", ["product_number"], :name => "index_refinery_store_products_on_product_number"
  add_index "refinery_store_products", ["retailer_id"], :name => "index_refinery_store_products_on_retailer_id"

  create_table "refinery_store_retailers", :force => true do |t|
    t.string   "name"
    t.string   "default_price_unit"
    t.integer  "position"
    t.date     "expired_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "refinery_store_retailers", ["expired_at"], :name => "index_refinery_store_retailers_on_expired_at"
  add_index "refinery_store_retailers", ["name"], :name => "index_refinery_store_retailers_on_name"
  add_index "refinery_store_retailers", ["position"], :name => "index_refinery_store_retailers_on_position"

  create_table "refinery_user_plugins", :force => true do |t|
    t.integer "user_id"
    t.string  "name"
    t.integer "position"
  end

  add_index "refinery_user_plugins", ["name"], :name => "index_refinery_user_plugins_on_name"
  add_index "refinery_user_plugins", ["user_id", "name"], :name => "index_refinery_user_plugins_on_user_id_and_name", :unique => true

  create_table "refinery_users", :force => true do |t|
    t.string   "username",               :null => false
    t.string   "email",                  :null => false
    t.string   "encrypted_password",     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "sign_in_count"
    t.datetime "remember_created_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "slug"
    t.datetime "password_changed_at"
    t.string   "full_name"
  end

  add_index "refinery_users", ["full_name"], :name => "index_refinery_users_on_full_name"
  add_index "refinery_users", ["id"], :name => "index_refinery_users_on_id"
  add_index "refinery_users", ["password_changed_at"], :name => "index_refinery_users_on_password_changed_at"
  add_index "refinery_users", ["slug"], :name => "index_refinery_users_on_slug"

  create_table "refinery_xero_accounts", :force => true do |t|
    t.string   "guid"
    t.string   "code"
    t.string   "name"
    t.string   "account_type"
    t.string   "account_class"
    t.string   "status"
    t.string   "currency_code"
    t.string   "tax_type"
    t.string   "description"
    t.string   "system_account"
    t.boolean  "enable_payments_account"
    t.boolean  "show_in_expense_claims"
    t.string   "bank_account_number"
    t.string   "reporting_code"
    t.string   "reporting_code_name"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.boolean  "inactive",                :default => false, :null => false
    t.boolean  "featured",                :default => false, :null => false
    t.text     "when_to_use"
  end

  add_index "refinery_xero_accounts", ["featured"], :name => "index_refinery_xero_accounts_on_featured"
  add_index "refinery_xero_accounts", ["guid"], :name => "index_refinery_xero_accounts_on_guid"
  add_index "refinery_xero_accounts", ["inactive"], :name => "index_refinery_xero_accounts_on_inactive"

  create_table "refinery_xero_api_keyfiles", :force => true do |t|
    t.string   "organisation"
    t.text     "key_content"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "refinery_xero_api_keyfiles", ["organisation"], :name => "index_refinery_xero_api_keyfiles_on_organisation"

  create_table "refinery_xero_contacts", :force => true do |t|
    t.string   "guid"
    t.string   "contact_number"
    t.string   "contact_status"
    t.string   "name"
    t.string   "tax_number"
    t.string   "bank_account_details"
    t.string   "accounts_receivable_tax_type"
    t.string   "accounts_payable_tax_type"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "skype_user_name"
    t.string   "contact_groups"
    t.string   "default_currency"
    t.datetime "updated_date_utc"
    t.boolean  "is_supplier",                  :default => false, :null => false
    t.boolean  "is_customer",                  :default => false, :null => false
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.boolean  "inactive",                     :default => false, :null => false
  end

  add_index "refinery_xero_contacts", ["guid"], :name => "index_refinery_xero_contacts_on_guid"
  add_index "refinery_xero_contacts", ["inactive"], :name => "index_refinery_xero_contacts_on_inactive"

  create_table "refinery_xero_expense_claim_attachments", :force => true do |t|
    t.integer  "xero_expense_claim_id"
    t.integer  "resource_id"
    t.string   "guid"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "refinery_xero_expense_claim_attachments", ["guid"], :name => "refinery_xeca_on_guid"
  add_index "refinery_xero_expense_claim_attachments", ["resource_id"], :name => "refinery_xeca_on_resource_id"
  add_index "refinery_xero_expense_claim_attachments", ["xero_expense_claim_id"], :name => "refinery_xeca_on_xero_expense_claim_id"

  create_table "refinery_xero_expense_claims", :force => true do |t|
    t.integer  "employee_id"
    t.string   "description"
    t.string   "guid"
    t.string   "status"
    t.decimal  "total",            :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal  "amount_due",       :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal  "amount_paid",      :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.date     "payment_due_date"
    t.date     "reporting_date"
    t.datetime "updated_date_utc"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.integer  "added_by_id"
  end

  add_index "refinery_xero_expense_claims", ["added_by_id"], :name => "index_refinery_xero_expense_claims_on_added_by_id"
  add_index "refinery_xero_expense_claims", ["employee_id"], :name => "index_refinery_xero_expense_claims_on_employee_id"
  add_index "refinery_xero_expense_claims", ["guid"], :name => "index_refinery_xero_expense_claims_on_guid"
  add_index "refinery_xero_expense_claims", ["updated_date_utc"], :name => "index_refinery_xero_expense_claims_on_updated_date_utc"

  create_table "refinery_xero_line_items", :force => true do |t|
    t.integer  "xero_receipt_id"
    t.integer  "xero_account_id"
    t.string   "item_code"
    t.string   "description"
    t.decimal  "quantity",                        :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal  "unit_amount",                     :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.string   "account_code"
    t.string   "tax_type"
    t.decimal  "tax_amount",                      :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal  "line_amount",                     :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.decimal  "discount_rate",                   :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.datetime "created_at",                                                                      :null => false
    t.datetime "updated_at",                                                                      :null => false
    t.text     "tracking_categories_and_options"
  end

  add_index "refinery_xero_line_items", ["xero_account_id"], :name => "index_refinery_xero_line_items_on_xero_account_id"
  add_index "refinery_xero_line_items", ["xero_receipt_id"], :name => "index_refinery_xero_line_items_on_xero_receipt_id"

  create_table "refinery_xero_receipts", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "xero_expense_claim_id"
    t.string   "guid"
    t.string   "receipt_number"
    t.string   "reference"
    t.string   "status"
    t.string   "line_amount_types"
    t.decimal  "sub_total",             :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.decimal  "total_tax",             :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.decimal  "total",                 :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.date     "date"
    t.string   "url"
    t.boolean  "has_attachments",                                      :default => false, :null => false
    t.datetime "updated_date_utc"
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
    t.integer  "xero_contact_id"
  end

  add_index "refinery_xero_receipts", ["employee_id"], :name => "index_refinery_xero_receipts_on_employee_id"
  add_index "refinery_xero_receipts", ["guid"], :name => "index_refinery_xero_receipts_on_guid"
  add_index "refinery_xero_receipts", ["updated_date_utc"], :name => "index_refinery_xero_receipts_on_updated_date_utc"
  add_index "refinery_xero_receipts", ["xero_contact_id"], :name => "index_refinery_xero_receipts_on_xero_contact_id"
  add_index "refinery_xero_receipts", ["xero_expense_claim_id"], :name => "index_refinery_xero_receipts_on_xero_expense_claim_id"

  create_table "refinery_xero_tracking_categories", :force => true do |t|
    t.string   "guid"
    t.string   "name"
    t.string   "status"
    t.text     "options"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "refinery_xero_tracking_categories", ["guid"], :name => "index_refinery_xero_tracking_categories_on_guid"
  add_index "refinery_xero_tracking_categories", ["name"], :name => "index_refinery_xero_tracking_categories_on_name"
  add_index "refinery_xero_tracking_categories", ["status"], :name => "index_refinery_xero_tracking_categories_on_status"

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

  create_table "user_settings", :force => true do |t|
    t.integer  "user_id"
    t.string   "identifier"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_settings", ["identifier"], :name => "index_user_settings_on_identifier"
  add_index "user_settings", ["user_id"], :name => "index_user_settings_on_user_id"

end
