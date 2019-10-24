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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20191024034447) do

  create_table "activity_notifications", force: :cascade do |t|
    t.integer  "target_id",       limit: 4,     null: false
    t.string   "target_type",     limit: 255,   null: false
    t.integer  "notifiable_id",   limit: 4,     null: false
    t.string   "notifiable_type", limit: 255,   null: false
    t.string   "key",             limit: 255,   null: false
    t.integer  "group_id",        limit: 4
    t.string   "group_type",      limit: 255
    t.integer  "group_owner_id",  limit: 4
    t.integer  "notifier_id",     limit: 4
    t.string   "notifier_type",   limit: 255
    t.text     "parameters",      limit: 65535
    t.datetime "opened_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "activity_notifications", ["group_owner_id"], name: "index_activity_notifications_on_group_owner_id", using: :btree
  add_index "activity_notifications", ["group_type", "group_id"], name: "index_notifications_on_group_id_and_type", using: :btree
  add_index "activity_notifications", ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_id_and_type", using: :btree
  add_index "activity_notifications", ["notifier_type", "notifier_id"], name: "index_notifications_on_notifier_id_and_type", using: :btree
  add_index "activity_notifications", ["target_type", "target_id"], name: "index_notifications_on_target_id_and_type", using: :btree

  create_table "amqp_messages", force: :cascade do |t|
    t.string   "queue",       limit: 255,   null: false
    t.text     "message",     limit: 65535, null: false
    t.text     "type",        limit: 65535, null: false
    t.integer  "sender_id",   limit: 4
    t.string   "sender_type", limit: 255
    t.datetime "sent_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "amqp_messages", ["sender_id", "sender_type"], name: "index_amqp_messages_on_sender_id_and_sender_type", using: :btree
  add_index "amqp_messages", ["sent_at"], name: "index_amqp_messages_on_sent_at", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "notifications_subscriptions", force: :cascade do |t|
    t.integer  "target_id",                limit: 4,                    null: false
    t.string   "target_type",              limit: 255,                  null: false
    t.string   "key",                      limit: 255,                  null: false
    t.boolean  "subscribing",                            default: true, null: false
    t.boolean  "subscribing_to_email",                   default: true, null: false
    t.datetime "subscribed_at"
    t.datetime "unsubscribed_at"
    t.datetime "subscribed_to_email_at"
    t.datetime "unsubscribed_to_email_at"
    t.text     "optional_targets",         limit: 65535
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
  end

  add_index "notifications_subscriptions", ["key"], name: "index_notifications_subscriptions_on_key", using: :btree
  add_index "notifications_subscriptions", ["target_type", "target_id", "key"], name: "index_subscriptions_on_target_id_type_and_key", unique: true, using: :btree
  add_index "notifications_subscriptions", ["target_type", "target_id"], name: "index_subscriptions_on_target_id_and_type", using: :btree

  create_table "refinery_amqp_messages", force: :cascade do |t|
    t.string   "queue",       limit: 255,   null: false
    t.text     "message",     limit: 65535, null: false
    t.text     "type",        limit: 65535, null: false
    t.integer  "sender_id",   limit: 4
    t.string   "sender_type", limit: 255
    t.datetime "sent_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "refinery_amqp_messages", ["sender_id", "sender_type"], name: "index_refinery_amqp_messages_on_sender_id_and_sender_type", using: :btree
  add_index "refinery_amqp_messages", ["sent_at"], name: "index_refinery_amqp_messages_on_sent_at", using: :btree

  create_table "refinery_annual_leave_records", force: :cascade do |t|
    t.integer  "employee_id",     limit: 4
    t.integer  "annual_leave_id", limit: 4
    t.string   "record_type",     limit: 255
    t.date     "record_date"
    t.decimal  "record_value",                precision: 10, scale: 2, default: 0.0, null: false
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
  end

  add_index "refinery_annual_leave_records", ["annual_leave_id"], name: "index_refinery_annual_leave_records_on_annual_leave_id", using: :btree
  add_index "refinery_annual_leave_records", ["employee_id"], name: "index_refinery_annual_leave_records_on_employee_id", using: :btree
  add_index "refinery_annual_leave_records", ["record_date"], name: "index_refinery_annual_leave_records_on_record_date", using: :btree
  add_index "refinery_annual_leave_records", ["record_type"], name: "index_refinery_annual_leave_records_on_record_type", using: :btree

  create_table "refinery_annual_leaves", force: :cascade do |t|
    t.integer  "employee_id",    limit: 4
    t.integer  "event_id",       limit: 4
    t.date     "start_date"
    t.boolean  "start_half_day",                                    default: false, null: false
    t.date     "end_date"
    t.boolean  "end_half_day",                                      default: false, null: false
    t.decimal  "number_of_days",           precision: 10, scale: 2, default: 0.0,   null: false
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
  end

  add_index "refinery_annual_leaves", ["employee_id"], name: "index_refinery_annual_leaves_on_employee_id", using: :btree
  add_index "refinery_annual_leaves", ["end_date"], name: "index_refinery_annual_leaves_on_end_date", using: :btree
  add_index "refinery_annual_leaves", ["event_id"], name: "index_refinery_annual_leaves_on_event_id", using: :btree
  add_index "refinery_annual_leaves", ["start_date"], name: "index_refinery_annual_leaves_on_start_date", using: :btree

  create_table "refinery_authentication_devise_roles", force: :cascade do |t|
    t.string "title", limit: 255
  end

  create_table "refinery_authentication_devise_roles_users", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "role_id", limit: 4
  end

  add_index "refinery_authentication_devise_roles_users", ["role_id", "user_id"], name: "refinery_roles_users_role_id_user_id", using: :btree
  add_index "refinery_authentication_devise_roles_users", ["user_id", "role_id"], name: "refinery_roles_users_user_id_role_id", using: :btree

  create_table "refinery_authentication_devise_user_plugins", force: :cascade do |t|
    t.integer "user_id",  limit: 4
    t.string  "name",     limit: 255
    t.integer "position", limit: 4
  end

  add_index "refinery_authentication_devise_user_plugins", ["name"], name: "index_refinery_authentication_devise_user_plugins_on_name", using: :btree
  add_index "refinery_authentication_devise_user_plugins", ["user_id", "name"], name: "refinery_user_plugins_user_id_name", unique: true, using: :btree

  create_table "refinery_authentication_devise_users", force: :cascade do |t|
    t.string   "username",               limit: 255,                 null: false
    t.string   "email",                  limit: 255,                 null: false
    t.string   "encrypted_password",     limit: 255,                 null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "sign_in_count",          limit: 4
    t.datetime "remember_created_at"
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "slug",                   limit: 255
    t.datetime "password_changed_at"
    t.string   "full_name",              limit: 255
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",       limit: 4
    t.integer  "invited_by_id",          limit: 4
    t.string   "invited_by_type",        limit: 255
    t.integer  "invitations_count",      limit: 4,   default: 0
    t.boolean  "deactivated",                        default: false, null: false
    t.string   "topo_id",                limit: 255
    t.datetime "last_active_at"
  end

  add_index "refinery_authentication_devise_users", ["full_name"], name: "index_refinery_authentication_devise_users_on_full_name", using: :btree
  add_index "refinery_authentication_devise_users", ["id"], name: "index_refinery_authentication_devise_users_on_id", using: :btree
  add_index "refinery_authentication_devise_users", ["invitation_token"], name: "index_refinery_authentication_devise_users_on_invitation_token", unique: true, using: :btree
  add_index "refinery_authentication_devise_users", ["invitations_count"], name: "index_refinery_authentication_devise_users_on_invitations_count", using: :btree
  add_index "refinery_authentication_devise_users", ["invited_by_id"], name: "index_refinery_authentication_devise_users_on_invited_by_id", using: :btree
  add_index "refinery_authentication_devise_users", ["last_active_at"], name: "index_refinery_authentication_devise_users_on_last_active_at", using: :btree
  add_index "refinery_authentication_devise_users", ["password_changed_at"], name: "refinery_devise_users_password_changed_at", using: :btree
  add_index "refinery_authentication_devise_users", ["slug"], name: "index_refinery_authentication_devise_users_on_slug", using: :btree
  add_index "refinery_authentication_devise_users", ["topo_id"], name: "index_refinery_authentication_devise_users_on_topo_id", using: :btree

  create_table "refinery_blog_categories", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "cached_slug", limit: 255
  end

  add_index "refinery_blog_categories", ["id"], name: "index_refinery_blog_categories_on_id", using: :btree

  create_table "refinery_blog_categories_blog_posts", force: :cascade do |t|
    t.integer "blog_category_id", limit: 4
    t.integer "blog_post_id",     limit: 4
  end

  add_index "refinery_blog_categories_blog_posts", ["blog_category_id", "blog_post_id"], name: "index_blog_categories_blog_posts_on_bc_and_bp", using: :btree

  create_table "refinery_blog_comments", force: :cascade do |t|
    t.integer  "blog_post_id", limit: 4
    t.boolean  "spam"
    t.string   "name",         limit: 255
    t.string   "email",        limit: 255
    t.text     "body",         limit: 65535
    t.string   "state",        limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "refinery_blog_comments", ["blog_post_id"], name: "index_refinery_blog_comments_on_blog_post_id", using: :btree
  add_index "refinery_blog_comments", ["id"], name: "index_refinery_blog_comments_on_id", using: :btree

  create_table "refinery_blog_posts", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.text     "body",          limit: 65535
    t.boolean  "draft"
    t.datetime "published_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "user_id",       limit: 4
    t.string   "cached_slug",   limit: 255
    t.string   "custom_url",    limit: 255
    t.text     "custom_teaser", limit: 65535
  end

  add_index "refinery_blog_posts", ["id"], name: "index_refinery_blog_posts_on_id", using: :btree

  create_table "refinery_brand_shows", force: :cascade do |t|
    t.integer  "brand_id",   limit: 4
    t.integer  "show_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "refinery_brand_shows", ["brand_id"], name: "index_refinery_brand_shows_on_brand_id", using: :btree
  add_index "refinery_brand_shows", ["show_id"], name: "index_refinery_brand_shows_on_show_id", using: :btree

  create_table "refinery_brands", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "website",     limit: 255
    t.integer  "logo_id",     limit: 4
    t.text     "description", limit: 65535
    t.integer  "position",    limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "refinery_business_accounts", force: :cascade do |t|
    t.string   "organisation",    limit: 255
    t.text     "key_content",     limit: 65535
    t.string   "consumer_key",    limit: 255
    t.string   "consumer_secret", limit: 255
    t.string   "encryption_key",  limit: 255
    t.integer  "position",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  en

  add_index "refinery_business_accounts", ["organisation"], name: "index_refinery_business_accounts_on_organisation", using: :btree
  add_index "refinery_business_accounts", ["position"], name: "index_refinery_business_accounts_on_position", using: :btree

  create_table "refinery_business_billables", force: :cascade do |t|
    t.integer  "company_id",        limit: 4
    t.integer  "project_id",        limit: 4
    t.integer  "section_id",        limit: 4
    t.integer  "invoice_id",        limit: 4
    t.string   "billable_type",     limit: 255
    t.string   "status",            limit: 255
    t.string   "title",             limit: 255
    t.text     "description",       limit: 65535
    t.string   "article_code",      limit: 255
    t.decimal  "qty",                             precision: 10
    t.string   "qty_unit",          limit: 255
    t.decimal  "unit_price",                      precision: 13, scale: 4, default: 0.0, null: false
    t.decimal  "discount",                        precision: 12, scale: 6, default: 0.0, null: false
    t.decimal  "total_cost",                      precision: 13, scale: 4, default: 0.0, null: false
    t.string   "account",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "billable_date"
    t.integer  "assigned_to_id",    limit: 4
    t.string   "assigned_to_label", limit: 255
    t.datetime "archived_at"
  end

  add_index "refinery_business_billables", ["account"], name: "index_refinery_business_billables_on_account", using: :btree
  add_index "refinery_business_billables", ["archived_at"], name: "INDEX_rb_billables_ON_archived_at", using: :btree
  add_index "refinery_business_billables", ["article_code"], name: "index_refinery_business_billables_on_article_code", using: :btree
  add_index "refinery_business_billables", ["assigned_to_id"], name: "INDEX_rb_billables_ON_assigned_to_id", using: :btree
  add_index "refinery_business_billables", ["assigned_to_label"], name: "INDEX_rb_billables_ON_assigned_to_label", using: :btree
  add_index "refinery_business_billables", ["billable_date"], name: "index_refinery_business_billables_on_billable_date", using: :btree
  add_index "refinery_business_billables", ["billable_type"], name: "index_refinery_business_billables_on_billable_type", using: :btree
  add_index "refinery_business_billables", ["company_id"], name: "index_refinery_business_billables_on_company_id", using: :btree
  add_index "refinery_business_billables", ["invoice_id"], name: "index_refinery_business_billables_on_invoice_id", using: :btree
  add_index "refinery_business_billables", ["project_id"], name: "index_refinery_business_billables_on_project_id", using: :btree
  add_index "refinery_business_billables", ["qty"], name: "index_refinery_business_billables_on_qty", using: :btree
  add_index "refinery_business_billables", ["qty_unit"], name: "index_refinery_business_billables_on_qty_unit", using: :btree
  add_index "refinery_business_billables", ["section_id"], name: "index_refinery_business_billables_on_section_id", using: :btree
  add_index "refinery_business_billables", ["status"], name: "index_refinery_business_billables_on_status", using: :btree
  add_index "refinery_business_billables", ["title"], name: "index_refinery_business_billables_on_title", using: :btree
  add_index "refinery_business_billables", ["total_cost"], name: "index_refinery_business_billables_on_total_cost", using: :btree
  add_index "refinery_business_billables", ["unit_price"], name: "index_refinery_business_billables_on_unit_price", using: :btree

  create_table "refinery_business_budget_items", force: :cascade do |t|
    t.integer  "budget_id",      limit: 4
    t.string   "description",    limit: 255
    t.integer  "no_of_products", limit: 4,                             default: 0,   null: false
    t.integer  "no_of_skus",     limit: 4,                             default: 0,   null: false
    t.decimal  "price",                        precision: 8, scale: 2, default: 0.0, null: false
    t.integer  "quantity",       limit: 4,                             default: 0,   null: false
    t.decimal  "margin",                       precision: 6, scale: 5, default: 0.0, null: false
    t.text     "comments",       limit: 65535,                                       null: false
    t.integer  "position",       limit: 4
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
  end

  add_index "refinery_business_budget_items", ["budget_id"], name: "index_refinery_business_budget_items_on_budget_id", using: :btree

  create_table "refinery_business_budgets", force: :cascade do |t|
    t.string   "description",             limit: 255,                           default: "",  null: false
    t.string   "customer_name",           limit: 255,                           default: "",  null: false
    t.integer  "customer_contact_id",     limit: 4
    t.date     "from_date"
    t.date     "to_date"
    t.string   "account_manager_name",    limit: 255,                           default: "",  null: false
    t.integer  "account_manager_user_id", limit: 4
    t.integer  "no_of_products",          limit: 4,                             default: 0,   null: false
    t.integer  "no_of_skus",              limit: 4,                             default: 0,   null: false
    t.decimal  "price",                                 precision: 8, scale: 2, default: 0.0, null: false
    t.integer  "quantity",                limit: 4,                             default: 0,   null: false
    t.decimal  "margin",                                precision: 6, scale: 5, default: 0.0, null: false
    t.text     "comments",                limit: 65535
    t.integer  "position",                limit: 4
    t.datetime "created_at",                                                                  null: false
    t.datetime "updated_at",                                                                  null: false
    t.decimal  "total",                                 precision: 8, scale: 2, default: 0.0, null: false
    t.decimal  "margin_total",                          precision: 8, scale: 2, default: 0.0, null: false
  end

  add_index "refinery_business_budgets", ["account_manager_user_id"], name: "index_refinery_business_budgets_on_account_manager_user_id", using: :btree
  add_index "refinery_business_budgets", ["customer_contact_id"], name: "index_refinery_business_budgets_on_customer_contact_id", using: :btree
  add_index "refinery_business_budgets", ["description"], name: "index_refinery_business_budgets_on_description", using: :btree

  create_table "refinery_business_companies", force: :cascade do |t|
    t.integer  "contact_id",   limit: 4
    t.string   "code",         limit: 255
    t.string   "name",         limit: 255
    t.integer  "position",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country_code", limit: 255
    t.string   "city",         limit: 255
  end

  add_index "refinery_business_companies", ["city"], name: "index_refinery_business_companies_on_city", using: :btree
  add_index "refinery_business_companies", ["code"], name: "index_refinery_business_companies_on_code", using: :btree
  add_index "refinery_business_companies", ["contact_id"], name: "index_refinery_business_companies_on_contact_id", using: :btree
  add_index "refinery_business_companies", ["country_code"], name: "index_refinery_business_companies_on_country_code", using: :btree
  add_index "refinery_business_companies", ["name"], name: "index_refinery_business_companies_on_name", using: :btree
  add_index "refinery_business_companies", ["position"], name: "index_refinery_business_companies_on_position", using: :btree

  create_table "refinery_business_company_users", force: :cascade do |t|
    t.integer  "company_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.string   "role",       limit: 255
    t.integer  "position",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refinery_business_company_users", ["company_id"], name: "index_refinery_business_company_users_on_company_id", using: :btree
  add_index "refinery_business_company_users", ["position"], name: "index_refinery_business_company_users_on_position", using: :btree
  add_index "refinery_business_company_users", ["role"], name: "index_refinery_business_company_users_on_role", using: :btree
  add_index "refinery_business_company_users", ["user_id"], name: "index_refinery_business_company_users_on_user_id", using: :btree

  create_table "refinery_business_invoices", force: :cascade do |t|
    t.integer  "account_id",         limit: 4
    t.string   "invoice_id",         limit: 255
    t.string   "contact_id",         limit: 255
    t.string   "invoice_number",     limit: 255
    t.string   "invoice_type",       limit: 255
    t.string   "reference",          limit: 255
    t.string   "invoice_url",        limit: 255
    t.date     "invoice_date"
    t.date     "due_date"
    t.string   "status",             limit: 255
    t.decimal  "total_amount",                   precision: 12, scale: 2, default: 0.0
    t.decimal  "amount_due",                     precision: 12, scale: 2, default: 0.0
    t.decimal  "amount_paid",                    precision: 12, scale: 2, default: 0.0
    t.decimal  "amount_credited",                precision: 8,  scale: 2, default: 0.0
    t.string   "currency_code",      limit: 255
    t.decimal  "currency_rate",                  precision: 12, scale: 6, default: 1.0
    t.datetime "updated_date_utc"
    t.integer  "position",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id",         limit: 4
    t.integer  "project_id",         limit: 4
    t.integer  "from_company_id",    limit: 4
    t.string   "from_company_label", limit: 255
    t.integer  "from_contact_id",    limit: 4
    t.integer  "to_company_id",      limit: 4
    t.string   "to_company_label",   limit: 255
    t.integer  "to_contact_id",      limit: 4
    t.datetime "archived_at"
  end

  add_index "refinery_business_invoices", ["account_id"], name: "index_refinery_business_invoices_on_account_id", using: :btree
  add_index "refinery_business_invoices", ["archived_at"], name: "INDEX_rb_invoices_ON_archived_at", using: :btree
  add_index "refinery_business_invoices", ["company_id"], name: "index_refinery_business_invoices_on_company_id", using: :btree
  add_index "refinery_business_invoices", ["contact_id"], name: "index_refinery_business_invoices_on_contact_id", using: :btree
  add_index "refinery_business_invoices", ["from_company_id"], name: "INDEX_rb_invoices_ON_from_company_id", using: :btree
  add_index "refinery_business_invoices", ["from_company_label"], name: "INDEX_rb_invoices_ON_from_company_label", using: :btree
  add_index "refinery_business_invoices", ["from_contact_id"], name: "INDEX_rb_invoices_ON_from_contact_id", using: :btree
  add_index "refinery_business_invoices", ["invoice_date"], name: "index_refinery_business_invoices_on_invoice_date", using: :btree
  add_index "refinery_business_invoices", ["invoice_id"], name: "index_refinery_business_invoices_on_invoice_id", using: :btree
  add_index "refinery_business_invoices", ["invoice_number"], name: "index_refinery_business_invoices_on_invoice_number", using: :btree
  add_index "refinery_business_invoices", ["invoice_type"], name: "index_refinery_business_invoices_on_invoice_type", using: :btree
  add_index "refinery_business_invoices", ["position"], name: "index_refinery_business_invoices_on_position", using: :btree
  add_index "refinery_business_invoices", ["project_id"], name: "index_refinery_business_invoices_on_project_id", using: :btree
  add_index "refinery_business_invoices", ["status"], name: "index_refinery_business_invoices_on_status", using: :btree
  add_index "refinery_business_invoices", ["to_company_id"], name: "INDEX_rb_invoices_ON_to_company_id", using: :btree
  add_index "refinery_business_invoices", ["to_company_label"], name: "INDEX_rb_invoices_ON_to_company_label", using: :btree
  add_index "refinery_business_invoices", ["to_contact_id"], name: "INDEX_rb_invoices_ON_to_contact_id", using: :btree
  add_index "refinery_business_invoices", ["total_amount"], name: "index_refinery_business_invoices_on_total_amount", using: :btree

  create_table "refinery_business_number_series", force: :cascade do |t|
    t.string   "identifier",       limit: 255
    t.integer  "last_counter",     limit: 4
    t.integer  "position",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "prefix",           limit: 255, default: "", null: false
    t.string   "suffix",           limit: 255, default: "", null: false
    t.integer  "number_of_digits", limit: 4,   default: 5,  null: false
  end

  add_index "refinery_business_number_series", ["identifier"], name: "index_refinery_business_number_series_on_identifier", using: :btree
  add_index "refinery_business_number_series", ["last_counter"], name: "index_refinery_business_number_series_on_last_counter", using: :btree
  add_index "refinery_business_number_series", ["position"], name: "index_refinery_business_number_series_on_position", using: :btree

  create_table "refinery_business_order_items", force: :cascade do |t|
    t.integer  "order_id",         limit: 4
    t.string   "order_item_id",    limit: 255
    t.integer  "line_item_number", limit: 4
    t.integer  "article_id",       limit: 4
    t.string   "article_code",     limit: 255
    t.string   "description",      limit: 255
    t.decimal  "ordered_qty",                  precision: 13, scale: 4, default: 0.0, null: false
    t.decimal  "shipped_qty",                  precision: 13, scale: 4
    t.string   "qty_unit",         limit: 255
    t.decimal  "unit_price",                   precision: 13, scale: 4, default: 0.0, null: false
    t.decimal  "discount",                     precision: 12, scale: 6, default: 0.0, null: false
    t.decimal  "total_cost",                   precision: 13, scale: 4, default: 0.0, null: false
    t.string   "account",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refinery_business_order_items", ["account"], name: "index_refinery_business_order_items_on_account", using: :btree
  add_index "refinery_business_order_items", ["article_code"], name: "index_refinery_business_order_items_on_article_code", using: :btree
  add_index "refinery_business_order_items", ["article_id"], name: "index_refinery_business_order_items_on_article_id", using: :btree
  add_index "refinery_business_order_items", ["line_item_number"], name: "index_refinery_business_order_items_on_line_item_number", using: :btree
  add_index "refinery_business_order_items", ["order_id"], name: "index_refinery_business_order_items_on_order_id", using: :btree
  add_index "refinery_business_order_items", ["order_item_id"], name: "index_refinery_business_order_items_on_order_item_id", using: :btree
  add_index "refinery_business_order_items", ["ordered_qty"], name: "index_refinery_business_order_items_on_ordered_qty", using: :btree
  add_index "refinery_business_order_items", ["qty_unit"], name: "index_refinery_business_order_items_on_qty_unit", using: :btree
  add_index "refinery_business_order_items", ["shipped_qty"], name: "index_refinery_business_order_items_on_shipped_qty", using: :btree
  add_index "refinery_business_order_items", ["total_cost"], name: "index_refinery_business_order_items_on_total_cost", using: :btree
  add_index "refinery_business_order_items", ["unit_price"], name: "index_refinery_business_order_items_on_unit_price", using: :btree

  create_table "refinery_business_orders", force: :cascade do |t|
    t.string   "order_id",               limit: 255
    t.integer  "buyer_id",               limit: 4
    t.string   "buyer_label",            limit: 255
    t.integer  "seller_id",              limit: 4
    t.string   "seller_label",           limit: 255
    t.integer  "project_id",             limit: 4
    t.string   "order_number",           limit: 255
    t.string   "order_type",             limit: 255
    t.date     "order_date"
    t.integer  "version_number",         limit: 4
    t.date     "revised_date"
    t.string   "reference",              limit: 255
    t.text     "description",            limit: 65535
    t.date     "delivery_date"
    t.text     "delivery_address",       limit: 65535
    t.text     "delivery_instructions",  limit: 65535
    t.string   "ship_mode",              limit: 255
    t.string   "shipment_terms",         limit: 255
    t.string   "attention_to",           limit: 255
    t.string   "status",                 limit: 255
    t.string   "proforma_invoice_label", limit: 255
    t.string   "invoice_label",          limit: 255
    t.decimal  "ordered_qty",                          precision: 13, scale: 4, default: 0.0, null: false
    t.decimal  "shipped_qty",                          precision: 13, scale: 4
    t.string   "qty_unit",               limit: 255
    t.string   "currency_code",          limit: 255
    t.decimal  "total_cost",                           precision: 13, scale: 4, default: 0.0, null: false
    t.string   "account",                limit: 255
    t.datetime "updated_date_utc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refinery_business_orders", ["account"], name: "index_refinery_business_orders_on_account", using: :btree
  add_index "refinery_business_orders", ["attention_to"], name: "index_refinery_business_orders_on_attention_to", using: :btree
  add_index "refinery_business_orders", ["buyer_id"], name: "index_refinery_business_orders_on_buyer_id", using: :btree
  add_index "refinery_business_orders", ["buyer_label"], name: "index_refinery_business_orders_on_buyer_label", using: :btree
  add_index "refinery_business_orders", ["currency_code"], name: "index_refinery_business_orders_on_currency_code", using: :btree
  add_index "refinery_business_orders", ["delivery_date"], name: "index_refinery_business_orders_on_delivery_date", using: :btree
  add_index "refinery_business_orders", ["invoice_label"], name: "index_refinery_business_orders_on_invoice_label", using: :btree
  add_index "refinery_business_orders", ["order_date"], name: "index_refinery_business_orders_on_order_date", using: :btree
  add_index "refinery_business_orders", ["order_id"], name: "index_refinery_business_orders_on_order_id", using: :btree
  add_index "refinery_business_orders", ["order_number"], name: "index_refinery_business_orders_on_order_number", using: :btree
  add_index "refinery_business_orders", ["order_type"], name: "index_refinery_business_orders_on_order_type", using: :btree
  add_index "refinery_business_orders", ["ordered_qty"], name: "index_refinery_business_orders_on_ordered_qty", using: :btree
  add_index "refinery_business_orders", ["proforma_invoice_label"], name: "index_refinery_business_orders_on_proforma_invoice_label", using: :btree
  add_index "refinery_business_orders", ["project_id"], name: "index_refinery_business_orders_on_project_id", using: :btree
  add_index "refinery_business_orders", ["qty_unit"], name: "index_refinery_business_orders_on_qty_unit", using: :btree
  add_index "refinery_business_orders", ["reference"], name: "index_refinery_business_orders_on_reference", using: :btree
  add_index "refinery_business_orders", ["revised_date"], name: "index_refinery_business_orders_on_revised_date", using: :btree
  add_index "refinery_business_orders", ["seller_id"], name: "index_refinery_business_orders_on_seller_id", using: :btree
  add_index "refinery_business_orders", ["seller_label"], name: "index_refinery_business_orders_on_seller_label", using: :btree
  add_index "refinery_business_orders", ["ship_mode"], name: "index_refinery_business_orders_on_ship_mode", using: :btree
  add_index "refinery_business_orders", ["shipment_terms"], name: "index_refinery_business_orders_on_shipment_terms", using: :btree
  add_index "refinery_business_orders", ["shipped_qty"], name: "index_refinery_business_orders_on_shipped_qty", using: :btree
  add_index "refinery_business_orders", ["status"], name: "index_refinery_business_orders_on_status", using: :btree
  add_index "refinery_business_orders", ["total_cost"], name: "index_refinery_business_orders_on_total_cost", using: :btree
  add_index "refinery_business_orders", ["updated_date_utc"], name: "index_refinery_business_orders_on_updated_date_utc", using: :btree
  add_index "refinery_business_orders", ["version_number"], name: "index_refinery_business_orders_on_version_number", using: :btree

  create_table "refinery_business_projects", force: :cascade do |t|
    t.integer  "company_id",        limit: 4
    t.string   "code",              limit: 255
    t.text     "description",       limit: 65535
    t.string   "status",            limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "position",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_reference", limit: 255
  end

  add_index "refinery_business_projects", ["code"], name: "index_refinery_business_projects_on_code", using: :btree
  add_index "refinery_business_projects", ["company_id"], name: "index_refinery_business_projects_on_company_id", using: :btree
  add_index "refinery_business_projects", ["company_reference"], name: "index_refinery_business_projects_on_company_reference", using: :btree
  add_index "refinery_business_projects", ["end_date"], name: "index_refinery_business_projects_on_end_date", using: :btree
  add_index "refinery_business_projects", ["position"], name: "index_refinery_business_projects_on_position", using: :btree
  add_index "refinery_business_projects", ["start_date"], name: "index_refinery_business_projects_on_start_date", using: :btree
  add_index "refinery_business_projects", ["status"], name: "index_refinery_business_projects_on_status", using: :btree

  create_table "refinery_business_sections", force: :cascade do |t|
    t.integer  "project_id",         limit: 4
    t.string   "section_type",       limit: 255
    t.text     "description",        limit: 65535
    t.date     "start_date"
    t.date     "end_date"
    t.string   "budgeted_resources", limit: 255
    t.integer  "position",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refinery_business_sections", ["end_date"], name: "index_refinery_business_sections_on_end_date", using: :btree
  add_index "refinery_business_sections", ["position"], name: "index_refinery_business_sections_on_position", using: :btree
  add_index "refinery_business_sections", ["project_id"], name: "index_refinery_business_sections_on_project_id", using: :btree
  add_index "refinery_business_sections", ["section_type"], name: "index_refinery_business_sections_on_section_type", using: :btree
  add_index "refinery_business_sections", ["start_date"], name: "index_refinery_business_sections_on_start_date", using: :btree

  create_table "refinery_calendar_calendars", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.string   "function",         limit: 255
    t.integer  "user_id",          limit: 4
    t.boolean  "private",                      default: false, null: false
    t.string   "default_rgb_code", limit: 255
    t.integer  "position",         limit: 4
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "refinery_calendar_calendars", ["function"], name: "index_refinery_calendar_calendars_on_function", using: :btree
  add_index "refinery_calendar_calendars", ["position"], name: "index_refinery_calendar_calendars_on_position", using: :btree
  add_index "refinery_calendar_calendars", ["private"], name: "index_refinery_calendar_calendars_on_private", using: :btree
  add_index "refinery_calendar_calendars", ["user_id"], name: "index_refinery_calendar_calendars_on_user_id", using: :btree

  create_table "refinery_calendar_events", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.string   "registration_link", limit: 255
    t.string   "excerpt",           limit: 255
    t.text     "description",       limit: 65535
    t.integer  "position",          limit: 4
    t.boolean  "featured"
    t.string   "slug",              limit: 255
    t.integer  "venue_id",          limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "calendar_id",       limit: 4
  end

  add_index "refinery_calendar_events", ["calendar_id"], name: "index_refinery_calendar_events_on_calendar_id", using: :btree

  create_table "refinery_calendar_google_calendars", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.integer  "primary_calendar_id", limit: 4
    t.string   "google_calendar_id",  limit: 255
    t.string   "refresh_token",       limit: 255
    t.integer  "sync_to_id",          limit: 4,   default: 0, null: false
    t.integer  "sync_from_id",        limit: 4,   default: 0, null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "refinery_calendar_google_calendars", ["google_calendar_id"], name: "index_rcgc_on_google_calendar_id", using: :btree
  add_index "refinery_calendar_google_calendars", ["primary_calendar_id"], name: "index_rcgc_on_primary_calendar_id", using: :btree
  add_index "refinery_calendar_google_calendars", ["user_id"], name: "index_rcgc_on_user_id", using: :btree

  create_table "refinery_calendar_google_events", force: :cascade do |t|
    t.integer  "google_calendar_id", limit: 4
    t.integer  "event_id",           limit: 4
    t.string   "google_event_id",    limit: 255
    t.datetime "last_synced_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "refinery_calendar_google_events", ["event_id"], name: "index_rcge_on_event_id", using: :btree
  add_index "refinery_calendar_google_events", ["google_calendar_id"], name: "index_rcge_on_google_calendar_id", using: :btree
  add_index "refinery_calendar_google_events", ["google_event_id"], name: "index_rcge_on_google_event_id", using: :btree

  create_table "refinery_calendar_user_calendars", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "calendar_id", limit: 4
    t.boolean  "inactive",                default: false, null: false
    t.string   "rgb_code",    limit: 255
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "refinery_calendar_user_calendars", ["calendar_id"], name: "index_refinery_calendar_user_calendars_on_calendar_id", using: :btree
  add_index "refinery_calendar_user_calendars", ["inactive"], name: "index_refinery_calendar_user_calendars_on_inactive", using: :btree
  add_index "refinery_calendar_user_calendars", ["user_id"], name: "index_refinery_calendar_user_calendars_on_user_id", using: :btree

  create_table "refinery_calendar_venues", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "address",    limit: 255
    t.string   "url",        limit: 255
    t.string   "phone",      limit: 255
    t.integer  "position",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "refinery_contacts", force: :cascade do |t|
    t.integer  "base_id",              limit: 4
    t.string   "name",                 limit: 255
    t.string   "first_name",           limit: 255
    t.string   "last_name",            limit: 255
    t.string   "address",              limit: 255
    t.string   "city",                 limit: 255
    t.string   "skype",                limit: 255
    t.string   "zip",                  limit: 255
    t.string   "country",              limit: 255
    t.string   "title",                limit: 255
    t.boolean  "private"
    t.integer  "contact_id",           limit: 4
    t.boolean  "is_organisation"
    t.string   "mobile",               limit: 255
    t.string   "fax",                  limit: 255
    t.string   "website",              limit: 255
    t.string   "phone",                limit: 255
    t.text     "description",          limit: 65535
    t.string   "linked_in",            limit: 255
    t.string   "facebook",             limit: 255
    t.string   "industry",             limit: 255
    t.string   "twitter",              limit: 255
    t.string   "email",                limit: 255
    t.string   "organisation_name",    limit: 255
    t.integer  "organisation_id",      limit: 4
    t.string   "tags_joined_by_comma", limit: 255
    t.boolean  "is_sales_account"
    t.string   "customer_status",      limit: 255
    t.string   "prospect_status",      limit: 255
    t.datetime "base_modified_at"
    t.text     "custom_fields",        limit: 65535
    t.integer  "position",             limit: 4
    t.boolean  "removed_from_base",                  default: false, null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "user_id",              limit: 4
    t.string   "state",                limit: 255
    t.integer  "insightly_id",         limit: 4
    t.string   "courier_company",      limit: 255
    t.string   "courier_account_no",   limit: 255
    t.string   "image_url",            limit: 255
    t.string   "code",                 limit: 255
    t.string   "xero_hr_id",           limit: 255
    t.string   "xero_hrt_id",          limit: 255
    t.string   "mailchimp_id",         limit: 255
    t.string   "other_address",        limit: 255
    t.string   "other_city",           limit: 255
    t.string   "other_zip",            limit: 255
    t.string   "other_state",          limit: 255
    t.string   "other_country",        limit: 255
    t.integer  "image_id",             limit: 4
  end

  add_index "refinery_contacts", ["base_id"], name: "index_refinery_contacts_on_base_id", using: :btree
  add_index "refinery_contacts", ["base_modified_at"], name: "index_refinery_contacts_on_base_modified_at", using: :btree
  add_index "refinery_contacts", ["code"], name: "index_refinery_contacts_on_code", using: :btree
  add_index "refinery_contacts", ["courier_company"], name: "index_refinery_contacts_on_courier_company", using: :btree
  add_index "refinery_contacts", ["image_id"], name: "index_refinery_contacts_on_image_id", using: :btree
  add_index "refinery_contacts", ["insightly_id"], name: "index_refinery_contacts_on_insightly_id", using: :btree
  add_index "refinery_contacts", ["mailchimp_id"], name: "index_refinery_contacts_on_mailchimp_id", using: :btree
  add_index "refinery_contacts", ["organisation_id"], name: "index_refinery_contacts_on_organisation_id", using: :btree
  add_index "refinery_contacts", ["removed_from_base"], name: "index_refinery_contacts_on_removed_from_base", using: :btree
  add_index "refinery_contacts", ["state"], name: "index_refinery_contacts_on_state", using: :btree
  add_index "refinery_contacts", ["user_id"], name: "index_refinery_contacts_on_user_id", using: :btree
  add_index "refinery_contacts", ["xero_hr_id"], name: "index_refinery_contacts_on_xero_hr_id", using: :btree
  add_index "refinery_contacts", ["xero_hrt_id"], name: "index_refinery_contacts_on_xero_hrt_id", using: :btree

  create_table "refinery_custom_lists_custom_lists", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.integer  "position",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "refinery_custom_lists_list_cells", force: :cascade do |t|
    t.integer  "list_row_id",    limit: 4
    t.integer  "list_column_id", limit: 4
    t.string   "value",          limit: 255
    t.integer  "position",       limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "refinery_custom_lists_list_cells", ["list_column_id"], name: "index_refinery_custom_lists_list_cells_on_list_column_id", using: :btree
  add_index "refinery_custom_lists_list_cells", ["list_row_id"], name: "index_refinery_custom_lists_list_cells_on_list_row_id", using: :btree
  add_index "refinery_custom_lists_list_cells", ["value"], name: "index_refinery_custom_lists_list_cells_on_value", using: :btree

  create_table "refinery_custom_lists_list_columns", force: :cascade do |t|
    t.integer  "custom_list_id", limit: 4
    t.string   "title",          limit: 255
    t.string   "column_type",    limit: 255
    t.integer  "position",       limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "refinery_custom_lists_list_columns", ["custom_list_id"], name: "index_refinery_custom_lists_list_columns_on_custom_list_id", using: :btree
  add_index "refinery_custom_lists_list_columns", ["position"], name: "index_refinery_custom_lists_list_columns_on_position", using: :btree

  create_table "refinery_custom_lists_list_rows", force: :cascade do |t|
    t.integer  "custom_list_id", limit: 4
    t.integer  "position",       limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "refinery_custom_lists_list_rows", ["custom_list_id"], name: "index_refinery_custom_lists_list_rows_on_custom_list_id", using: :btree
  add_index "refinery_custom_lists_list_rows", ["position"], name: "index_refinery_custom_lists_list_rows_on_position", using: :btree

  create_table "refinery_employees", force: :cascade do |t|
    t.integer  "user_id",                  limit: 4
    t.integer  "profile_image_id",         limit: 4
    t.string   "employee_no",              limit: 255
    t.string   "full_name",                limit: 255
    t.string   "id_no",                    limit: 255
    t.string   "title",                    limit: 255
    t.integer  "position",                 limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "xero_guid",                limit: 255
    t.text     "default_tracking_options", limit: 65535
    t.integer  "reporting_manager_id",     limit: 4
    t.integer  "contact_id",               limit: 4
    t.string   "emergency_contact",        limit: 255
    t.date     "birthday"
  end

  add_index "refinery_employees", ["birthday"], name: "index_refinery_employees_on_birthday", using: :btree
  add_index "refinery_employees", ["contact_id"], name: "index_refinery_employees_on_contact_id", using: :btree
  add_index "refinery_employees", ["employee_no"], name: "index_refinery_employees_on_employee_no", using: :btree
  add_index "refinery_employees", ["position"], name: "index_refinery_employees_on_position", using: :btree
  add_index "refinery_employees", ["profile_image_id"], name: "index_refinery_employees_on_profile_image_id", using: :btree
  add_index "refinery_employees", ["reporting_manager_id"], name: "index_refinery_employees_on_reporting_manager_id", using: :btree
  add_index "refinery_employees", ["user_id"], name: "index_refinery_employees_on_user_id", using: :btree

  create_table "refinery_employment_contracts", force: :cascade do |t|
    t.integer  "employee_id",            limit: 4,                                          null: false
    t.date     "start_date",                                                                null: false
    t.date     "end_date"
    t.decimal  "vacation_days_per_year",             precision: 10,           default: 0,   null: false
    t.decimal  "days_carried_over",                  precision: 10, scale: 2, default: 0.0, null: false
    t.string   "country",                limit: 255
    t.datetime "created_at",                                                                null: false
    t.datetime "updated_at",                                                                null: false
  end

  add_index "refinery_employment_contracts", ["employee_id"], name: "index_refinery_employment_contracts_on_employee_id", using: :btree
  add_index "refinery_employment_contracts", ["end_date"], name: "index_refinery_employment_contracts_on_end_date", using: :btree
  add_index "refinery_employment_contracts", ["start_date"], name: "index_refinery_employment_contracts_on_start_date", using: :btree

  create_table "refinery_image_page_translations", force: :cascade do |t|
    t.integer  "refinery_image_page_id", limit: 4
    t.string   "locale",                 limit: 255,   null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.text     "caption",                limit: 65535
  end

  add_index "refinery_image_page_translations", ["locale"], name: "index_refinery_image_page_translations_on_locale", using: :btree
  add_index "refinery_image_page_translations", ["refinery_image_page_id"], name: "index_186c9a170a0ab319c675aa80880ce155d8f47244", using: :btree

  create_table "refinery_image_pages", force: :cascade do |t|
    t.integer "image_id",  limit: 4
    t.integer "page_id",   limit: 4
    t.integer "position",  limit: 4
    t.text    "caption",   limit: 65535
    t.string  "page_type", limit: 255,   default: "page"
  end

  add_index "refinery_image_pages", ["image_id"], name: "index_refinery_image_pages_on_image_id", using: :btree
  add_index "refinery_image_pages", ["page_id"], name: "index_refinery_image_pages_on_page_id", using: :btree

  create_table "refinery_image_translations", force: :cascade do |t|
    t.integer  "refinery_image_id", limit: 4,   null: false
    t.string   "locale",            limit: 255, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "image_alt",         limit: 255
    t.string   "image_title",       limit: 255
  end

  add_index "refinery_image_translations", ["locale"], name: "index_refinery_image_translations_on_locale", using: :btree
  add_index "refinery_image_translations", ["refinery_image_id"], name: "index_refinery_image_translations_on_refinery_image_id", using: :btree

  create_table "refinery_images", force: :cascade do |t|
    t.string   "image_mime_type",       limit: 255
    t.string   "image_name",            limit: 255
    t.integer  "image_size",            limit: 4
    t.integer  "image_width",           limit: 4
    t.integer  "image_height",          limit: 4
    t.string   "image_uid",             limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "image_title",           limit: 255
    t.string   "image_alt",             limit: 255
    t.string   "authorizations_access", limit: 255
  end

  add_index "refinery_images", ["authorizations_access"], name: "index_refinery_images_on_authorizations_access", using: :btree

  create_table "refinery_leave_of_absences", force: :cascade do |t|
    t.integer  "employee_id",              limit: 4
    t.integer  "event_id",                 limit: 4
    t.integer  "doctors_note_id",          limit: 4
    t.integer  "absence_type_id",          limit: 4
    t.string   "absence_type_description", limit: 255
    t.integer  "status",                   limit: 4
    t.date     "start_date"
    t.boolean  "start_half_day",                       default: false, null: false
    t.date     "end_date"
    t.boolean  "end_half_day",                         default: false, null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "refinery_leave_of_absences", ["absence_type_id"], name: "index_refinery_leave_of_absences_on_absence_type_id", using: :btree
  add_index "refinery_leave_of_absences", ["doctors_note_id"], name: "index_refinery_leave_of_absences_on_doctors_note_id", using: :btree
  add_index "refinery_leave_of_absences", ["employee_id"], name: "index_refinery_leave_of_absences_on_employee_id", using: :btree
  add_index "refinery_leave_of_absences", ["end_date"], name: "index_refinery_leave_of_absences_on_end_date", using: :btree
  add_index "refinery_leave_of_absences", ["event_id"], name: "index_refinery_leave_of_absences_on_event_id", using: :btree
  add_index "refinery_leave_of_absences", ["start_date"], name: "index_refinery_leave_of_absences_on_start_date", using: :btree
  add_index "refinery_leave_of_absences", ["status"], name: "index_refinery_leave_of_absences_on_status", using: :btree

  create_table "refinery_news_item_translations", force: :cascade do |t|
    t.integer  "refinery_news_item_id", limit: 4
    t.string   "locale",                limit: 255,   null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "title",                 limit: 255
    t.text     "body",                  limit: 65535
    t.string   "source",                limit: 255
    t.string   "slug",                  limit: 255
  end

  add_index "refinery_news_item_translations", ["locale"], name: "index_refinery_news_item_translations_on_locale", using: :btree
  add_index "refinery_news_item_translations", ["refinery_news_item_id"], name: "index_refinery_news_item_translations_fk", using: :btree

  create_table "refinery_news_items", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.text     "body",            limit: 65535
    t.datetime "publish_date"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "image_id",        limit: 4
    t.datetime "expiration_date"
    t.string   "source",          limit: 255
    t.string   "slug",            limit: 255
  end

  add_index "refinery_news_items", ["id"], name: "index_refinery_news_items_on_id", using: :btree

  create_table "refinery_page_part_translations", force: :cascade do |t|
    t.integer  "refinery_page_part_id", limit: 4
    t.string   "locale",                limit: 255,   null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "body",                  limit: 65535
  end

  add_index "refinery_page_part_translations", ["locale"], name: "index_refinery_page_part_translations_on_locale", using: :btree
  add_index "refinery_page_part_translations", ["refinery_page_part_id"], name: "index_refinery_page_part_translations_on_refinery_page_part_id", using: :btree

  create_table "refinery_page_parts", force: :cascade do |t|
    t.integer  "refinery_page_id", limit: 4
    t.string   "slug",             limit: 255
    t.text     "body",             limit: 65535
    t.integer  "position",         limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "title",            limit: 255
  end

  add_index "refinery_page_parts", ["id"], name: "index_refinery_page_parts_on_id", using: :btree
  add_index "refinery_page_parts", ["refinery_page_id"], name: "index_refinery_page_parts_on_refinery_page_id", using: :btree

  create_table "refinery_page_roles", force: :cascade do |t|
    t.integer  "page_id",    limit: 4
    t.integer  "role_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "refinery_page_roles", ["page_id", "role_id"], name: "index_refinery_page_roles_on_page_id_and_role_id", using: :btree

  create_table "refinery_page_translations", force: :cascade do |t|
    t.integer  "refinery_page_id", limit: 4
    t.string   "locale",           limit: 255, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "title",            limit: 255
    t.string   "custom_slug",      limit: 255
    t.string   "menu_title",       limit: 255
    t.string   "slug",             limit: 255
  end

  add_index "refinery_page_translations", ["locale"], name: "index_refinery_page_translations_on_locale", using: :btree
  add_index "refinery_page_translations", ["refinery_page_id"], name: "index_refinery_page_translations_on_refinery_page_id", using: :btree

  create_table "refinery_pages", force: :cascade do |t|
    t.integer  "parent_id",           limit: 4
    t.string   "path",                limit: 255
    t.string   "slug",                limit: 255
    t.boolean  "show_in_menu",                    default: true
    t.string   "link_url",            limit: 255
    t.string   "menu_match",          limit: 255
    t.boolean  "deletable",                       default: true
    t.boolean  "draft",                           default: false
    t.boolean  "skip_to_first_child",             default: false
    t.integer  "lft",                 limit: 4
    t.integer  "rgt",                 limit: 4
    t.integer  "depth",               limit: 4
    t.string   "view_template",       limit: 255
    t.string   "layout_template",     limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "custom_slug",         limit: 255
  end

  add_index "refinery_pages", ["depth"], name: "index_refinery_pages_on_depth", using: :btree
  add_index "refinery_pages", ["id"], name: "index_refinery_pages_on_id", using: :btree
  add_index "refinery_pages", ["lft"], name: "index_refinery_pages_on_lft", using: :btree
  add_index "refinery_pages", ["parent_id"], name: "index_refinery_pages_on_parent_id", using: :btree
  add_index "refinery_pages", ["rgt"], name: "index_refinery_pages_on_rgt", using: :btree

  create_table "refinery_public_holidays", force: :cascade do |t|
    t.integer  "event_id",     limit: 4
    t.string   "title",        limit: 255
    t.string   "country",      limit: 255
    t.date     "holiday_date",                             null: false
    t.boolean  "half_day",                 default: false, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "refinery_public_holidays", ["event_id"], name: "index_refinery_public_holidays_on_event_id", using: :btree
  add_index "refinery_public_holidays", ["holiday_date"], name: "index_refinery_public_holidays_on_holiday_date", using: :btree

  create_table "refinery_quality_assurance_defects", force: :cascade do |t|
    t.integer  "category_code", limit: 4
    t.string   "category_name", limit: 255
    t.integer  "defect_code",   limit: 4
    t.string   "defect_name",   limit: 255
    t.integer  "position",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refinery_quality_assurance_defects", ["category_code"], name: "index_qa_defects_on_category_code", using: :btree
  add_index "refinery_quality_assurance_defects", ["category_name"], name: "index_qa_defects_on_category_name", using: :btree
  add_index "refinery_quality_assurance_defects", ["defect_code"], name: "index_qa_defects_on_defect_code", using: :btree
  add_index "refinery_quality_assurance_defects", ["defect_name"], name: "index_qa_defects_on_defect_name", using: :btree

  create_table "refinery_quality_assurance_inspection_defects", force: :cascade do |t|
    t.integer  "inspection_id", limit: 4
    t.integer  "defect_id",     limit: 4
    t.integer  "critical",      limit: 4,   default: 0, null: false
    t.integer  "major",         limit: 4,   default: 0, null: false
    t.integer  "minor",         limit: 4,   default: 0, null: false
    t.string   "comments",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "defect_label",  limit: 255
    t.boolean  "can_fix"
  end

  add_index "refinery_quality_assurance_inspection_defects", ["defect_id"], name: "index_qa_inspection_defects_on_defect_id", using: :btree
  add_index "refinery_quality_assurance_inspection_defects", ["inspection_id"], name: "index_qa_inspection_defects_on_inspection_id", using: :btree

  create_table "refinery_quality_assurance_inspection_photos", force: :cascade do |t|
    t.integer  "inspection_id",        limit: 4
    t.integer  "inspection_defect_id", limit: 4
    t.integer  "image_id",             limit: 4
    t.string   "file_id",              limit: 255
    t.text     "fields",               limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refinery_quality_assurance_inspection_photos", ["file_id"], name: "index_qa_inspection_photos_on_file_id", using: :btree
  add_index "refinery_quality_assurance_inspection_photos", ["image_id"], name: "index_qa_inspection_photos_on_image_id", using: :btree
  add_index "refinery_quality_assurance_inspection_photos", ["inspection_defect_id"], name: "index_qa_inspection_photos_on_inspection_defect_id", using: :btree
  add_index "refinery_quality_assurance_inspection_photos", ["inspection_id"], name: "index_qa_inspection_photos_on_inspection_id", using: :btree

  create_table "refinery_quality_assurance_inspections", force: :cascade do |t|
    t.integer  "company_id",                limit: 4
    t.integer  "supplier_id",               limit: 4
    t.string   "supplier_label",            limit: 255
    t.integer  "business_section_id",       limit: 4
    t.integer  "business_product_id",       limit: 4
    t.integer  "assigned_to_id",            limit: 4
    t.integer  "resource_id",               limit: 4
    t.integer  "inspected_by_id",           limit: 4
    t.string   "inspected_by_name",         limit: 255
    t.string   "document_id",               limit: 255
    t.string   "result",                    limit: 255
    t.date     "inspection_date"
    t.integer  "inspection_sample_size",    limit: 4
    t.string   "inspection_type",           limit: 255
    t.string   "po_number",                 limit: 255
    t.string   "po_type",                   limit: 255
    t.integer  "po_qty",                    limit: 4
    t.integer  "available_qty",             limit: 4
    t.string   "product_code",              limit: 255
    t.string   "product_description",       limit: 255
    t.string   "product_colour_variants",   limit: 255
    t.string   "inspection_standard",       limit: 255
    t.integer  "acc_critical",              limit: 4
    t.integer  "acc_major",                 limit: 4
    t.integer  "acc_minor",                 limit: 4
    t.integer  "total_critical",            limit: 4,     default: 0, null: false
    t.integer  "total_major",               limit: 4,     default: 0, null: false
    t.integer  "total_minor",               limit: 4,     default: 0, null: false
    t.integer  "position",                  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "fields",                    limit: 65535
    t.string   "company_label",             limit: 255
    t.integer  "inspection_photo_id",       limit: 4
    t.string   "company_code",              limit: 255
    t.string   "supplier_code",             limit: 255
    t.integer  "manufacturer_id",           limit: 4
    t.string   "manufacturer_label",        limit: 255
    t.string   "manufacturer_code",         limit: 255
    t.string   "status",                    limit: 255
    t.string   "company_project_reference", limit: 255
    t.string   "project_code",              limit: 255
    t.string   "code",                      limit: 255
    t.integer  "job_id",                    limit: 4
  end

  add_index "refinery_quality_assurance_inspections", ["assigned_to_id"], name: "index_qa_inspections_on_assigned_to_id", using: :btree
  add_index "refinery_quality_assurance_inspections", ["business_product_id"], name: "index_qa_inspections_on_business_product_id", using: :btree
  add_index "refinery_quality_assurance_inspections", ["business_section_id"], name: "index_qa_inspections_on_business_section_id", using: :btree
  add_index "refinery_quality_assurance_inspections", ["code"], name: "index_refinery_quality_assurance_inspections_on_code", using: :btree
  add_index "refinery_quality_assurance_inspections", ["company_code"], name: "index_qa_inspections_on_company_code", using: :btree
  add_index "refinery_quality_assurance_inspections", ["company_id"], name: "index_qa_inspections_on_company_id", using: :btree
  add_index "refinery_quality_assurance_inspections", ["company_project_reference"], name: "index_qa_inspections_on_company_project_reference", using: :btree
  add_index "refinery_quality_assurance_inspections", ["document_id"], name: "index_qa_inspections_on_document_id", using: :btree
  add_index "refinery_quality_assurance_inspections", ["inspection_date"], name: "index_qa_inspections_on_inspection_date", using: :btree
  add_index "refinery_quality_assurance_inspections", ["inspection_photo_id"], name: "index_qa_inspections_on_inspection_photo_id", using: :btree
  add_index "refinery_quality_assurance_inspections", ["inspection_type"], name: "index_qa_inspections_on_inspection_type", using: :btree
  add_index "refinery_quality_assurance_inspections", ["job_id"], name: "index_qa_inspections_on_job_id", using: :btree
  add_index "refinery_quality_assurance_inspections", ["manufacturer_code"], name: "index_qa_inspections_on_manufacturer_code", using: :btree
  add_index "refinery_quality_assurance_inspections", ["manufacturer_id"], name: "index_qa_inspections_on_manufacturer_id", using: :btree
  add_index "refinery_quality_assurance_inspections", ["manufacturer_label"], name: "index_qa_inspections_on_manufacturer_label", using: :btree
  add_index "refinery_quality_assurance_inspections", ["po_number"], name: "index_qa_inspections_on_po_number", using: :btree
  add_index "refinery_quality_assurance_inspections", ["po_qty"], name: "index_qa_inspections_on_po_qty", using: :btree
  add_index "refinery_quality_assurance_inspections", ["po_type"], name: "index_qa_inspections_on_po_type", using: :btree
  add_index "refinery_quality_assurance_inspections", ["position"], name: "index_qa_inspections_on_position", using: :btree
  add_index "refinery_quality_assurance_inspections", ["product_code"], name: "index_qa_inspections_on_product_code", using: :btree
  add_index "refinery_quality_assurance_inspections", ["product_description"], name: "index_qa_inspections_on_product_description", using: :btree
  add_index "refinery_quality_assurance_inspections", ["project_code"], name: "index_refinery_quality_assurance_inspections_on_project_code", using: :btree
  add_index "refinery_quality_assurance_inspections", ["resource_id"], name: "index_qa_inspections_on_resource_id", using: :btree
  add_index "refinery_quality_assurance_inspections", ["result"], name: "index_qa_inspections_on_result", using: :btree
  add_index "refinery_quality_assurance_inspections", ["status"], name: "index_refinery_quality_assurance_inspections_on_status", using: :btree
  add_index "refinery_quality_assurance_inspections", ["supplier_code"], name: "index_qa_inspections_on_supplier_code", using: :btree
  add_index "refinery_quality_assurance_inspections", ["supplier_id"], name: "index_qa_inspections_on_supplier_id", using: :btree

  create_table "refinery_quality_assurance_jobs", force: :cascade do |t|
    t.integer  "company_id",                limit: 4
    t.string   "company_code",              limit: 255
    t.string   "company_label",             limit: 255
    t.integer  "project_id",                limit: 4
    t.string   "project_code",              limit: 255
    t.string   "company_project_reference", limit: 255
    t.integer  "section_id",                limit: 4
    t.string   "billable_type",             limit: 255
    t.integer  "billable_id",               limit: 4
    t.string   "status",                    limit: 255
    t.string   "code",                      limit: 255
    t.string   "title",                     limit: 255
    t.text     "description",               limit: 65535
    t.integer  "assigned_to_id",            limit: 4
    t.string   "assigned_to_label",         limit: 255
    t.string   "job_type",                  limit: 255
    t.date     "inspection_date"
    t.decimal  "time_spent",                              precision: 8, scale: 2, default: 0.0, null: false
    t.text     "time_log",                  limit: 65535
    t.integer  "position",                  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refinery_quality_assurance_jobs", ["assigned_to_id"], name: "index_qa_inspection_jobs_on_assigned_to_id", using: :btree
  add_index "refinery_quality_assurance_jobs", ["assigned_to_label"], name: "index_qa_inspection_jobs_on_assigned_to_label", using: :btree
  add_index "refinery_quality_assurance_jobs", ["billable_id"], name: "index_qa_inspection_jobs_on_billable_id", using: :btree
  add_index "refinery_quality_assurance_jobs", ["billable_type"], name: "index_qa_inspection_jobs_on_billable_type", using: :btree
  add_index "refinery_quality_assurance_jobs", ["code"], name: "index_qa_inspection_jobs_on_code", using: :btree
  add_index "refinery_quality_assurance_jobs", ["company_code"], name: "index_qa_inspection_jobs_on_company_code", using: :btree
  add_index "refinery_quality_assurance_jobs", ["company_id"], name: "index_qa_inspection_jobs_on_company_id", using: :btree
  add_index "refinery_quality_assurance_jobs", ["company_label"], name: "index_qa_inspection_jobs_on_company_label", using: :btree
  add_index "refinery_quality_assurance_jobs", ["company_project_reference"], name: "index_qa_inspection_jobs_on_company_project_reference", using: :btree
  add_index "refinery_quality_assurance_jobs", ["inspection_date"], name: "index_qa_inspection_jobs_on_inspection_date", using: :btree
  add_index "refinery_quality_assurance_jobs", ["job_type"], name: "index_qa_inspection_jobs_on_job_type", using: :btree
  add_index "refinery_quality_assurance_jobs", ["position"], name: "index_qa_inspection_jobs_on_position", using: :btree
  add_index "refinery_quality_assurance_jobs", ["project_code"], name: "index_qa_inspection_jobs_on_project_code", using: :btree
  add_index "refinery_quality_assurance_jobs", ["project_id"], name: "index_qa_inspection_jobs_on_project_id", using: :btree
  add_index "refinery_quality_assurance_jobs", ["section_id"], name: "index_qa_inspection_jobs_on_section_id", using: :btree
  add_index "refinery_quality_assurance_jobs", ["status"], name: "index_qa_inspection_jobs_on_status", using: :btree
  add_index "refinery_quality_assurance_jobs", ["title"], name: "index_qa_inspection_jobs_on_title", using: :btree

  create_table "refinery_resource_translations", force: :cascade do |t|
    t.integer  "refinery_resource_id", limit: 4,   null: false
    t.string   "locale",               limit: 255, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "resource_title",       limit: 255
  end

  add_index "refinery_resource_translations", ["locale"], name: "index_refinery_resource_translations_on_locale", using: :btree
  add_index "refinery_resource_translations", ["refinery_resource_id"], name: "index_refinery_resource_translations_on_refinery_resource_id", using: :btree

  create_table "refinery_resources", force: :cascade do |t|
    t.string   "file_mime_type",        limit: 255
    t.string   "file_name",             limit: 255
    t.integer  "file_size",             limit: 4
    t.string   "file_uid",              limit: 255
    t.string   "file_ext",              limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "authorizations_access", limit: 255
  end

  add_index "refinery_resources", ["authorizations_access"], name: "index_refinery_resources_on_authorizations_access", using: :btree

  create_table "refinery_settings", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.text     "value",           limit: 65535
    t.boolean  "destroyable",                   default: true
    t.string   "scoping",         limit: 255
    t.boolean  "restricted",                    default: false
    t.string   "form_value_type", limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "slug",            limit: 255
  end

  add_index "refinery_settings", ["name"], name: "index_refinery_settings_on_name", using: :btree

  create_table "refinery_shipping_addresses", force: :cascade do |t|
    t.string   "easy_post_id", limit: 255
    t.string   "name",         limit: 255
    t.string   "company",      limit: 255
    t.string   "street1",      limit: 255
    t.string   "street2",      limit: 255
    t.string   "city",         limit: 255
    t.string   "state",        limit: 255
    t.string   "zip",          limit: 255
    t.string   "country",      limit: 255
    t.string   "phone",        limit: 255
    t.string   "email",        limit: 255
    t.integer  "position",     limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "refinery_shipping_addresses", ["easy_post_id"], name: "index_refinery_shipping_addresses_on_easy_post_id", using: :btree
  add_index "refinery_shipping_addresses", ["position"], name: "index_refinery_shipping_addresses_on_position", using: :btree

  create_table "refinery_shipping_items", force: :cascade do |t|
    t.integer  "shipment_id",      limit: 4
    t.integer  "order_id",         limit: 4
    t.string   "order_label",      limit: 255
    t.integer  "order_item_id",    limit: 4
    t.string   "article_code",     limit: 255
    t.string   "description",      limit: 255
    t.string   "hs_code_label",    limit: 255
    t.boolean  "partial_shipment",                                      default: false, null: false
    t.decimal  "qty",                          precision: 13, scale: 4
    t.integer  "item_order",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refinery_shipping_items", ["article_code"], name: "index_refinery_shipping_items_on_article_code", using: :btree
  add_index "refinery_shipping_items", ["description"], name: "index_refinery_shipping_items_on_description", using: :btree
  add_index "refinery_shipping_items", ["hs_code_label"], name: "index_refinery_shipping_items_on_hs_code_label", using: :btree
  add_index "refinery_shipping_items", ["item_order"], name: "index_refinery_shipping_items_on_item_order", using: :btree
  add_index "refinery_shipping_items", ["order_id"], name: "index_refinery_shipping_items_on_order_id", using: :btree
  add_index "refinery_shipping_items", ["order_item_id"], name: "index_refinery_shipping_items_on_order_item_id", using: :btree
  add_index "refinery_shipping_items", ["order_label"], name: "index_refinery_shipping_items_on_order_label", using: :btree
  add_index "refinery_shipping_items", ["partial_shipment"], name: "index_refinery_shipping_items_on_partial_shipment", using: :btree
  add_index "refinery_shipping_items", ["shipment_id"], name: "index_refinery_shipping_items_on_shipment_id", using: :btree

  create_table "refinery_shipping_locations", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.text     "description",           limit: 65535
    t.integer  "owner_id",              limit: 4
    t.string   "location_type",         limit: 255
    t.boolean  "airport",                                                     default: false, null: false
    t.boolean  "railport",                                                    default: false, null: false
    t.boolean  "roadport",                                                    default: false, null: false
    t.boolean  "seaport",                                                     default: false, null: false
    t.string   "location_code",         limit: 255
    t.string   "iata_code",             limit: 255
    t.string   "icao_code",             limit: 255
    t.string   "street1",               limit: 255
    t.string   "street2",               limit: 255
    t.string   "city",                  limit: 255
    t.string   "state",                 limit: 255
    t.string   "postal_code",           limit: 255
    t.string   "country",               limit: 255
    t.string   "country_code",          limit: 255
    t.string   "timezone",              limit: 255
    t.decimal  "lat",                                 precision: 9, scale: 6
    t.decimal  "lng",                                 precision: 9, scale: 6
    t.string   "customs_district_code", limit: 255
    t.datetime "confirmed_at"
    t.datetime "verified_at"
    t.datetime "archived_at"
    t.boolean  "public",                                                      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refinery_shipping_locations", ["airport"], name: "index_refinery_shipping_locations_on_airport", using: :btree
  add_index "refinery_shipping_locations", ["archived_at"], name: "index_refinery_shipping_locations_on_archived_at", using: :btree
  add_index "refinery_shipping_locations", ["city"], name: "index_refinery_shipping_locations_on_city", using: :btree
  add_index "refinery_shipping_locations", ["confirmed_at"], name: "index_refinery_shipping_locations_on_confirmed_at", using: :btree
  add_index "refinery_shipping_locations", ["country"], name: "index_refinery_shipping_locations_on_country", using: :btree
  add_index "refinery_shipping_locations", ["country_code"], name: "index_refinery_shipping_locations_on_country_code", using: :btree
  add_index "refinery_shipping_locations", ["customs_district_code"], name: "index_refinery_shipping_locations_on_customs_district_code", using: :btree
  add_index "refinery_shipping_locations", ["iata_code"], name: "index_refinery_shipping_locations_on_iata_code", using: :btree
  add_index "refinery_shipping_locations", ["icao_code"], name: "index_refinery_shipping_locations_on_icao_code", using: :btree
  add_index "refinery_shipping_locations", ["lat"], name: "index_refinery_shipping_locations_on_lat", using: :btree
  add_index "refinery_shipping_locations", ["lng"], name: "index_refinery_shipping_locations_on_lng", using: :btree
  add_index "refinery_shipping_locations", ["location_code"], name: "index_refinery_shipping_locations_on_location_code", using: :btree
  add_index "refinery_shipping_locations", ["location_type"], name: "index_refinery_shipping_locations_on_location_type", using: :btree
  add_index "refinery_shipping_locations", ["name"], name: "index_refinery_shipping_locations_on_name", using: :btree
  add_index "refinery_shipping_locations", ["owner_id"], name: "index_refinery_shipping_locations_on_owner_id", using: :btree
  add_index "refinery_shipping_locations", ["postal_code"], name: "index_refinery_shipping_locations_on_postal_code", using: :btree
  add_index "refinery_shipping_locations", ["public"], name: "index_refinery_shipping_locations_on_public", using: :btree
  add_index "refinery_shipping_locations", ["railport"], name: "index_refinery_shipping_locations_on_railport", using: :btree
  add_index "refinery_shipping_locations", ["roadport"], name: "index_refinery_shipping_locations_on_roadport", using: :btree
  add_index "refinery_shipping_locations", ["seaport"], name: "index_refinery_shipping_locations_on_seaport", using: :btree
  add_index "refinery_shipping_locations", ["state"], name: "index_refinery_shipping_locations_on_state", using: :btree
  add_index "refinery_shipping_locations", ["street1"], name: "index_refinery_shipping_locations_on_street1", using: :btree
  add_index "refinery_shipping_locations", ["street2"], name: "index_refinery_shipping_locations_on_street2", using: :btree
  add_index "refinery_shipping_locations", ["timezone"], name: "index_refinery_shipping_locations_on_timezone", using: :btree
  add_index "refinery_shipping_locations", ["verified_at"], name: "index_refinery_shipping_locations_on_verified_at", using: :btree

  create_table "refinery_shipping_packages", force: :cascade do |t|
    t.integer  "shipment_id",          limit: 4
    t.string   "name",                 limit: 255
    t.string   "package_type",         limit: 255
    t.decimal  "total_packages",                   precision: 13, scale: 4
    t.string   "length_unit",          limit: 255
    t.decimal  "package_length",                   precision: 13, scale: 4
    t.decimal  "package_width",                    precision: 13, scale: 4
    t.decimal  "package_height",                   precision: 13, scale: 4
    t.string   "volume_unit",          limit: 255
    t.decimal  "package_volume",                   precision: 13, scale: 4
    t.string   "weight_unit",          limit: 255
    t.decimal  "package_gross_weight",             precision: 13, scale: 4
    t.integer  "package_order",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "package_net_weight",               precision: 13, scale: 4
  end

  add_index "refinery_shipping_packages", ["name"], name: "index_refinery_shipping_packages_on_name", using: :btree
  add_index "refinery_shipping_packages", ["package_order"], name: "index_refinery_shipping_packages_on_package_order", using: :btree
  add_index "refinery_shipping_packages", ["package_type"], name: "index_refinery_shipping_packages_on_package_type", using: :btree
  add_index "refinery_shipping_packages", ["shipment_id"], name: "index_refinery_shipping_packages_on_shipment_id", using: :btree

  create_table "refinery_shipping_parcels", force: :cascade do |t|
    t.date     "parcel_date"
    t.string   "from_name",            limit: 255
    t.integer  "from_contact_id",      limit: 4
    t.string   "courier",              limit: 255
    t.string   "air_waybill_no",       limit: 255
    t.string   "to_name",              limit: 255
    t.integer  "to_user_id",           limit: 4
    t.integer  "shipping_document_id", limit: 4
    t.boolean  "receiver_signed",                  default: false, null: false
    t.integer  "position",             limit: 4
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "received_by_id",       limit: 4
    t.integer  "assigned_to_id",       limit: 4
    t.string   "description",          limit: 255
  end

  add_index "refinery_shipping_parcels", ["assigned_to_id"], name: "index_refinery_shipping_parcels_on_assigned_to_id", using: :btree
  add_index "refinery_shipping_parcels", ["from_contact_id"], name: "index_refinery_shipping_parcels_on_from_contact_id", using: :btree
  add_index "refinery_shipping_parcels", ["position"], name: "index_refinery_shipping_parcels_on_position", using: :btree
  add_index "refinery_shipping_parcels", ["received_by_id"], name: "index_refinery_shipping_parcels_on_received_by_id", using: :btree
  add_index "refinery_shipping_parcels", ["receiver_signed"], name: "index_refinery_shipping_parcels_on_receiver_signed", using: :btree
  add_index "refinery_shipping_parcels", ["shipping_document_id"], name: "index_refinery_shipping_parcels_on_shipping_document_id", using: :btree
  add_index "refinery_shipping_parcels", ["to_user_id"], name: "index_refinery_shipping_parcels_on_to_user_id", using: :btree

  create_table "refinery_shipping_routes", force: :cascade do |t|
    t.integer  "shipment_id",       limit: 4
    t.integer  "location_id",       limit: 4
    t.string   "route_type",        limit: 255
    t.string   "route_description", limit: 255
    t.text     "notes",             limit: 65535
    t.string   "status",            limit: 255
    t.datetime "arrived_at"
    t.datetime "departed_at"
    t.integer  "prior_route_id",    limit: 4
    t.boolean  "final_destination",               default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refinery_shipping_routes", ["arrived_at"], name: "index_refinery_shipping_routes_on_arrived_at", using: :btree
  add_index "refinery_shipping_routes", ["departed_at"], name: "index_refinery_shipping_routes_on_departed_at", using: :btree
  add_index "refinery_shipping_routes", ["final_destination"], name: "index_refinery_shipping_routes_on_final_destination", using: :btree
  add_index "refinery_shipping_routes", ["location_id"], name: "index_refinery_shipping_routes_on_location_id", using: :btree
  add_index "refinery_shipping_routes", ["prior_route_id"], name: "index_refinery_shipping_routes_on_prior_route_id", using: :btree
  add_index "refinery_shipping_routes", ["route_description"], name: "index_refinery_shipping_routes_on_route_description", using: :btree
  add_index "refinery_shipping_routes", ["route_type"], name: "index_refinery_shipping_routes_on_route_type", using: :btree
  add_index "refinery_shipping_routes", ["shipment_id"], name: "index_refinery_shipping_routes_on_shipment_id", using: :btree
  add_index "refinery_shipping_routes", ["status"], name: "index_refinery_shipping_routes_on_status", using: :btree

  create_table "refinery_shipping_shipment_accounts", force: :cascade do |t|
    t.integer  "contact_id",  limit: 4
    t.string   "description", limit: 255
    t.string   "courier",     limit: 255
    t.string   "account_no",  limit: 255
    t.text     "comments",    limit: 65535
    t.integer  "position",    limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "refinery_shipping_shipment_accounts", ["account_no"], name: "index_refinery_shipping_shipment_accounts_on_account_no", using: :btree
  add_index "refinery_shipping_shipment_accounts", ["contact_id"], name: "index_refinery_shipping_shipment_accounts_on_contact_id", using: :btree
  add_index "refinery_shipping_shipment_accounts", ["courier"], name: "index_refinery_shipping_shipment_accounts_on_courier", using: :btree
  add_index "refinery_shipping_shipment_accounts", ["position"], name: "index_refinery_shipping_shipment_accounts_on_position", using: :btree

  create_table "refinery_shipping_shipment_parcels", force: :cascade do |t|
    t.integer  "shipment_id",        limit: 4
    t.integer  "length",             limit: 4
    t.integer  "width",              limit: 4
    t.integer  "height",             limit: 4
    t.integer  "weight",             limit: 4
    t.string   "predefined_package", limit: 255
    t.integer  "position",           limit: 4
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.string   "description",        limit: 255
    t.integer  "quantity",           limit: 4,                           default: 0, null: false
    t.decimal  "value",                          precision: 8, scale: 2
    t.string   "origin_country",     limit: 255
    t.string   "contents_type",      limit: 255
  end

  add_index "refinery_shipping_shipment_parcels", ["position"], name: "index_refinery_shipping_shipment_parcels_on_position", using: :btree

  create_table "refinery_shipping_shipments", force: :cascade do |t|
    t.integer  "from_contact_id",                     limit: 4
    t.integer  "from_address_id",                     limit: 4
    t.integer  "to_contact_id",                       limit: 4
    t.integer  "to_address_id",                       limit: 4
    t.integer  "created_by_id",                       limit: 4
    t.integer  "assigned_to_id",                      limit: 4
    t.string   "courier_company_label",               limit: 255
    t.integer  "position",                            limit: 4
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
    t.integer  "bill_to_account_id",                  limit: 4
    t.string   "bill_to",                             limit: 255
    t.string   "description",                         limit: 255
    t.string   "label_url",                           limit: 255
    t.string   "tracking_number",                     limit: 255
    t.string   "tracking_status",                     limit: 255
    t.string   "status",                              limit: 255
    t.string   "easypost_object_id",                  limit: 255
    t.text     "rates_content",                       limit: 65535
    t.string   "rate_object_id",                      limit: 255
    t.string   "rate_service",                        limit: 255
    t.decimal  "rate_amount",                                       precision: 13, scale: 4
    t.string   "rate_currency",                       limit: 255
    t.date     "etd_date"
    t.text     "tracking_info",                       limit: 65535
    t.integer  "project_id",                          limit: 4
    t.string   "code",                                limit: 255
    t.integer  "receiver_company_id",                 limit: 4
    t.integer  "shipper_company_id",                  limit: 4
    t.integer  "consignee_company_id",                limit: 4
    t.integer  "consignee_address_id",                limit: 4
    t.string   "consignee_reference",                 limit: 255
    t.string   "mode",                                limit: 255
    t.string   "forwarder_company_label",             limit: 255
    t.string   "forwarder_booking_number",            limit: 255
    t.string   "comments",                            limit: 255
    t.integer  "no_of_parcels",                       limit: 4
    t.decimal  "duty_amount",                                       precision: 13, scale: 4
    t.decimal  "terminal_fee_amount",                               precision: 13, scale: 4
    t.decimal  "domestic_transportation_cost_amount",               precision: 13, scale: 4
    t.decimal  "forwarding_fee_amount",                             precision: 13, scale: 4
    t.decimal  "freight_cost_amount",                               precision: 13, scale: 4
    t.decimal  "volume_amount",                                     precision: 13, scale: 4
    t.decimal  "volume_manual_amount",                              precision: 13, scale: 4
    t.string   "volume_unit",                         limit: 255
    t.decimal  "gross_weight_amount",                               precision: 13, scale: 4
    t.decimal  "gross_weight_manual_amount",                        precision: 13, scale: 4
    t.decimal  "net_weight_amount",                                 precision: 13, scale: 4
    t.decimal  "net_weight_manual_amount",                          precision: 13, scale: 4
    t.decimal  "chargeable_weight_amount",                          precision: 13, scale: 4
    t.decimal  "chargeable_weight_manual_amount",                   precision: 13, scale: 4
    t.string   "weight_unit",                         limit: 255
    t.string   "from_contact_label",                  limit: 255
    t.string   "shipper_company_label",               limit: 255
    t.string   "to_contact_label",                    limit: 255
    t.string   "receiver_company_label",              limit: 255
    t.string   "consignee_company_label",             limit: 255
    t.string   "created_by_label",                    limit: 255
    t.string   "assigned_to_label",                   limit: 255
    t.date     "eta_date"
    t.integer  "supplier_company_id",                 limit: 4
    t.string   "supplier_company_label",              limit: 255
    t.integer  "forwarder_company_id",                limit: 4
    t.string   "load_port",                           limit: 255
    t.integer  "courier_company_id",                  limit: 4
    t.string   "shipment_terms",                      limit: 255
    t.text     "shipment_terms_details",              limit: 65535
    t.datetime "archived_at"
    t.string   "length_unit",                         limit: 255
  end

  add_index "refinery_shipping_shipments", ["archived_at"], name: "index_refinery_shipping_shipments_on_archived_at", using: :btree
  add_index "refinery_shipping_shipments", ["assigned_to_id"], name: "index_refinery_shipping_shipments_on_assigned_to_id", using: :btree
  add_index "refinery_shipping_shipments", ["assigned_to_label"], name: "index_refinery_shipping_shipments_on_assigned_to_label", using: :btree
  add_index "refinery_shipping_shipments", ["bill_to_account_id"], name: "index_refinery_parcels_shipments_on_bta_id", using: :btree
  add_index "refinery_shipping_shipments", ["code"], name: "index_refinery_shipping_shipments_on_code", using: :btree
  add_index "refinery_shipping_shipments", ["comments"], name: "index_refinery_shipping_shipments_on_comments", using: :btree
  add_index "refinery_shipping_shipments", ["consignee_address_id"], name: "index_refinery_shipping_shipments_on_consignee_address_id", using: :btree
  add_index "refinery_shipping_shipments", ["consignee_company_id"], name: "index_refinery_shipping_shipments_on_consignee_company_id", using: :btree
  add_index "refinery_shipping_shipments", ["consignee_company_label"], name: "index_refinery_shipping_shipments_on_consignee_company_label", using: :btree
  add_index "refinery_shipping_shipments", ["consignee_reference"], name: "index_refinery_shipping_shipments_on_consignee_reference", using: :btree
  add_index "refinery_shipping_shipments", ["courier_company_id"], name: "index_refinery_shipping_shipments_on_courier_company_id", using: :btree
  add_index "refinery_shipping_shipments", ["created_by_id"], name: "index_refinery_shipping_shipments_on_created_by_id", using: :btree
  add_index "refinery_shipping_shipments", ["created_by_label"], name: "index_refinery_shipping_shipments_on_created_by_label", using: :btree
  add_index "refinery_shipping_shipments", ["easypost_object_id"], name: "index_refinery_parcels_shipments_on_eo_id", using: :btree
  add_index "refinery_shipping_shipments", ["eta_date"], name: "index_refinery_shipping_shipments_on_eta_date", using: :btree
  add_index "refinery_shipping_shipments", ["forwarder_booking_number"], name: "index_refinery_shipping_shipments_on_forwarder_booking_number", using: :btree
  add_index "refinery_shipping_shipments", ["forwarder_company_id"], name: "index_refinery_shipping_shipments_on_forwarder_company_id", using: :btree
  add_index "refinery_shipping_shipments", ["forwarder_company_label"], name: "index_refinery_shipping_shipments_on_forwarder_company_label", using: :btree
  add_index "refinery_shipping_shipments", ["from_address_id"], name: "index_refinery_shipping_shipments_on_from_address_id", using: :btree
  add_index "refinery_shipping_shipments", ["from_contact_id"], name: "index_refinery_shipping_shipments_on_from_contact_id", using: :btree
  add_index "refinery_shipping_shipments", ["from_contact_label"], name: "index_refinery_shipping_shipments_on_from_contact_label", using: :btree
  add_index "refinery_shipping_shipments", ["mode"], name: "index_refinery_shipping_shipments_on_mode", using: :btree
  add_index "refinery_shipping_shipments", ["no_of_parcels"], name: "index_refinery_shipping_shipments_on_no_of_parcels", using: :btree
  add_index "refinery_shipping_shipments", ["position"], name: "index_refinery_shipping_shipments_on_position", using: :btree
  add_index "refinery_shipping_shipments", ["project_id"], name: "index_refinery_shipping_shipments_on_project_id", using: :btree
  add_index "refinery_shipping_shipments", ["receiver_company_id"], name: "index_refinery_shipping_shipments_on_receiver_company_id", using: :btree
  add_index "refinery_shipping_shipments", ["receiver_company_label"], name: "index_refinery_shipping_shipments_on_receiver_company_label", using: :btree
  add_index "refinery_shipping_shipments", ["shipment_terms"], name: "index_refinery_shipping_shipments_on_shipment_terms", using: :btree
  add_index "refinery_shipping_shipments", ["shipper_company_id"], name: "index_refinery_shipping_shipments_on_shipper_company_id", using: :btree
  add_index "refinery_shipping_shipments", ["shipper_company_label"], name: "index_refinery_shipping_shipments_on_shipper_company_label", using: :btree
  add_index "refinery_shipping_shipments", ["status"], name: "index_refinery_shipping_shipments_on_status", using: :btree
  add_index "refinery_shipping_shipments", ["supplier_company_id"], name: "index_refinery_shipping_shipments_on_supplier_company_id", using: :btree
  add_index "refinery_shipping_shipments", ["supplier_company_label"], name: "index_refinery_shipping_shipments_on_supplier_company_label", using: :btree
  add_index "refinery_shipping_shipments", ["to_address_id"], name: "index_refinery_shipping_shipments_on_to_address_id", using: :btree
  add_index "refinery_shipping_shipments", ["to_contact_id"], name: "index_refinery_shipping_shipments_on_to_contact_id", using: :btree
  add_index "refinery_shipping_shipments", ["to_contact_label"], name: "index_refinery_shipping_shipments_on_to_contact_label", using: :btree

  create_table "refinery_shows", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "website",            limit: 255
    t.integer  "logo_id",            limit: 4
    t.text     "description",        limit: 65535
    t.text     "msg_json_struct",    limit: 65535
    t.datetime "last_sync_datetime"
    t.string   "last_sync_result",   limit: 255
    t.integer  "position",           limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "refinery_sick_leaves", force: :cascade do |t|
    t.integer  "employee_id",     limit: 4
    t.integer  "event_id",        limit: 4
    t.integer  "doctors_note_id", limit: 4
    t.date     "start_date"
    t.boolean  "start_half_day",                                     default: false, null: false
    t.date     "end_date"
    t.boolean  "end_half_day",                                       default: false, null: false
    t.decimal  "number_of_days",            precision: 10, scale: 2, default: 0.0,   null: false
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
  end

  add_index "refinery_sick_leaves", ["doctors_note_id"], name: "index_refinery_sick_leaves_on_doctors_note_id", using: :btree
  add_index "refinery_sick_leaves", ["employee_id"], name: "index_refinery_sick_leaves_on_employee_id", using: :btree
  add_index "refinery_sick_leaves", ["end_date"], name: "index_refinery_sick_leaves_on_end_date", using: :btree
  add_index "refinery_sick_leaves", ["event_id"], name: "index_refinery_sick_leaves_on_event_id", using: :btree
  add_index "refinery_sick_leaves", ["start_date"], name: "index_refinery_sick_leaves_on_start_date", using: :btree

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

  create_table "refinery_xero_accounts", force: :cascade do |t|
    t.string   "guid",                    limit: 255
    t.string   "code",                    limit: 255
    t.string   "name",                    limit: 255
    t.string   "account_type",            limit: 255
    t.string   "account_class",           limit: 255
    t.string   "status",                  limit: 255
    t.string   "currency_code",           limit: 255
    t.string   "tax_type",                limit: 255
    t.string   "description",             limit: 255
    t.string   "system_account",          limit: 255
    t.boolean  "enable_payments_account"
    t.boolean  "show_in_expense_claims"
    t.string   "bank_account_number",     limit: 255
    t.string   "reporting_code",          limit: 255
    t.string   "reporting_code_name",     limit: 255
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.boolean  "inactive",                              default: false, null: false
    t.boolean  "featured",                              default: false, null: false
    t.text     "when_to_use",             limit: 65535
  end

  add_index "refinery_xero_accounts", ["featured"], name: "index_refinery_xero_accounts_on_featured", using: :btree
  add_index "refinery_xero_accounts", ["guid"], name: "index_refinery_xero_accounts_on_guid", using: :btree
  add_index "refinery_xero_accounts", ["inactive"], name: "index_refinery_xero_accounts_on_inactive", using: :btree

  create_table "refinery_xero_api_keyfiles", force: :cascade do |t|
    t.string   "organisation",    limit: 255
    t.text     "key_content",     limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "consumer_key",    limit: 255
    t.string   "consumer_secret", limit: 255
    t.string   "encryption_key",  limit: 255
  end

  add_index "refinery_xero_api_keyfiles", ["organisation"], name: "index_refinery_xero_api_keyfiles_on_organisation", using: :btree

  create_table "refinery_xero_contacts", force: :cascade do |t|
    t.string   "guid",                         limit: 255
    t.string   "contact_number",               limit: 255
    t.string   "contact_status",               limit: 255
    t.string   "name",                         limit: 255
    t.string   "tax_number",                   limit: 255
    t.string   "bank_account_details",         limit: 255
    t.string   "accounts_receivable_tax_type", limit: 255
    t.string   "accounts_payable_tax_type",    limit: 255
    t.string   "first_name",                   limit: 255
    t.string   "last_name",                    limit: 255
    t.string   "email_address",                limit: 255
    t.string   "skype_user_name",              limit: 255
    t.string   "contact_groups",               limit: 255
    t.string   "default_currency",             limit: 255
    t.datetime "updated_date_utc"
    t.boolean  "is_supplier",                              default: false, null: false
    t.boolean  "is_customer",                              default: false, null: false
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.boolean  "inactive",                                 default: false, null: false
  end

  add_index "refinery_xero_contacts", ["guid"], name: "index_refinery_xero_contacts_on_guid", using: :btree
  add_index "refinery_xero_contacts", ["inactive"], name: "index_refinery_xero_contacts_on_inactive", using: :btree

  create_table "refinery_xero_expense_claim_attachments", force: :cascade do |t|
    t.integer  "xero_expense_claim_id", limit: 4
    t.integer  "resource_id",           limit: 4
    t.string   "guid",                  limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "refinery_xero_expense_claim_attachments", ["guid"], name: "refinery_xeca_on_guid", using: :btree
  add_index "refinery_xero_expense_claim_attachments", ["resource_id"], name: "refinery_xeca_on_resource_id", using: :btree
  add_index "refinery_xero_expense_claim_attachments", ["xero_expense_claim_id"], name: "refinery_xeca_on_xero_expense_claim_id", using: :btree

  create_table "refinery_xero_expense_claims", force: :cascade do |t|
    t.integer  "employee_id",      limit: 4
    t.string   "description",      limit: 255
    t.string   "guid",             limit: 255
    t.string   "status",           limit: 255
    t.decimal  "total",                        precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "amount_due",                   precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "amount_paid",                  precision: 10, scale: 2, default: 0.0, null: false
    t.date     "payment_due_date"
    t.date     "reporting_date"
    t.datetime "updated_date_utc"
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.integer  "added_by_id",      limit: 4
    t.string   "error_reason",     limit: 255
  end

  add_index "refinery_xero_expense_claims", ["added_by_id"], name: "index_refinery_xero_expense_claims_on_added_by_id", using: :btree
  add_index "refinery_xero_expense_claims", ["employee_id"], name: "index_refinery_xero_expense_claims_on_employee_id", using: :btree
  add_index "refinery_xero_expense_claims", ["guid"], name: "index_refinery_xero_expense_claims_on_guid", using: :btree
  add_index "refinery_xero_expense_claims", ["updated_date_utc"], name: "index_refinery_xero_expense_claims_on_updated_date_utc", using: :btree

  create_table "refinery_xero_line_items", force: :cascade do |t|
    t.integer  "xero_receipt_id",                 limit: 4
    t.integer  "xero_account_id",                 limit: 4
    t.string   "item_code",                       limit: 255
    t.string   "description",                     limit: 255
    t.decimal  "quantity",                                      precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "unit_amount",                                   precision: 10, scale: 2, default: 0.0, null: false
    t.string   "account_code",                    limit: 255
    t.string   "tax_type",                        limit: 255
    t.decimal  "tax_amount",                                    precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "line_amount",                                   precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "discount_rate",                                 precision: 10, scale: 2, default: 0.0, null: false
    t.datetime "created_at",                                                                           null: false
    t.datetime "updated_at",                                                                           null: false
    t.text     "tracking_categories_and_options", limit: 65535
  end

  add_index "refinery_xero_line_items", ["xero_account_id"], name: "index_refinery_xero_line_items_on_xero_account_id", using: :btree
  add_index "refinery_xero_line_items", ["xero_receipt_id"], name: "index_refinery_xero_line_items_on_xero_receipt_id", using: :btree

  create_table "refinery_xero_receipts", force: :cascade do |t|
    t.integer  "employee_id",           limit: 4
    t.integer  "xero_expense_claim_id", limit: 4
    t.string   "guid",                  limit: 255
    t.string   "receipt_number",        limit: 255
    t.string   "reference",             limit: 255
    t.string   "status",                limit: 255
    t.string   "line_amount_types",     limit: 255
    t.decimal  "sub_total",                         precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "total_tax",                         precision: 10, scale: 2, default: 0.0,   null: false
    t.decimal  "total",                             precision: 10, scale: 2, default: 0.0,   null: false
    t.date     "date"
    t.string   "url",                   limit: 255
    t.boolean  "has_attachments",                                            default: false, null: false
    t.datetime "updated_date_utc"
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
    t.integer  "xero_contact_id",       limit: 4
  end

  add_index "refinery_xero_receipts", ["employee_id"], name: "index_refinery_xero_receipts_on_employee_id", using: :btree
  add_index "refinery_xero_receipts", ["guid"], name: "index_refinery_xero_receipts_on_guid", using: :btree
  add_index "refinery_xero_receipts", ["updated_date_utc"], name: "index_refinery_xero_receipts_on_updated_date_utc", using: :btree
  add_index "refinery_xero_receipts", ["xero_contact_id"], name: "index_refinery_xero_receipts_on_xero_contact_id", using: :btree
  add_index "refinery_xero_receipts", ["xero_expense_claim_id"], name: "index_refinery_xero_receipts_on_xero_expense_claim_id", using: :btree

  create_table "refinery_xero_tracking_categories", force: :cascade do |t|
    t.string   "guid",       limit: 255
    t.string   "name",       limit: 255
    t.string   "status",     limit: 255
    t.text     "options",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "refinery_xero_tracking_categories", ["guid"], name: "index_refinery_xero_tracking_categories_on_guid", using: :btree
  add_index "refinery_xero_tracking_categories", ["name"], name: "index_refinery_xero_tracking_categories_on_name", using: :btree
  add_index "refinery_xero_tracking_categories", ["status"], name: "index_refinery_xero_tracking_categories_on_status", using: :btree

  create_table "seo_meta", force: :cascade do |t|
    t.integer  "seo_meta_id",      limit: 4
    t.string   "seo_meta_type",    limit: 255
    t.string   "browser_title",    limit: 255
    t.text     "meta_description", limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "seo_meta", ["id"], name: "index_seo_meta_on_id", using: :btree
  add_index "seo_meta", ["seo_meta_id", "seo_meta_type"], name: "id_type_index_on_seo_meta", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 255
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "user_settings", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "identifier", limit: 255
    t.text     "content",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "user_settings", ["identifier"], name: "index_user_settings_on_identifier", using: :btree
  add_index "user_settings", ["user_id"], name: "index_user_settings_on_user_id", using: :btree

end
