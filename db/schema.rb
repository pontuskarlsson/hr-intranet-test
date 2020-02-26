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

ActiveRecord::Schema.define(version: 20200210075429) do

  create_table "activity_notifications", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "target_id", null: false
    t.string "target_type", null: false
    t.integer "notifiable_id", null: false
    t.string "notifiable_type", null: false
    t.string "key", null: false
    t.integer "group_id"
    t.string "group_type"
    t.integer "group_owner_id"
    t.integer "notifier_id"
    t.string "notifier_type"
    t.text "parameters"
    t.datetime "opened_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_owner_id"], name: "index_activity_notifications_on_group_owner_id"
    t.index ["group_type", "group_id"], name: "index_notifications_on_group_id_and_type"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_id_and_type"
    t.index ["notifier_type", "notifier_id"], name: "index_notifications_on_notifier_id_and_type"
    t.index ["target_type", "target_id"], name: "index_notifications_on_target_id_and_type"
  end

  create_table "delayed_jobs", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "notifications_subscriptions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "target_id", null: false
    t.string "target_type", null: false
    t.string "key", null: false
    t.boolean "subscribing", default: true, null: false
    t.boolean "subscribing_to_email", default: true, null: false
    t.datetime "subscribed_at"
    t.datetime "unsubscribed_at"
    t.datetime "subscribed_to_email_at"
    t.datetime "unsubscribed_to_email_at"
    t.text "optional_targets"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_notifications_subscriptions_on_key"
    t.index ["target_type", "target_id", "key"], name: "index_subscriptions_on_target_id_type_and_key", unique: true
    t.index ["target_type", "target_id"], name: "index_subscriptions_on_target_id_and_type"
  end

  create_table "oauth_access_grants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "refinery_annual_leave_records", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "employee_id"
    t.integer "annual_leave_id"
    t.string "record_type"
    t.date "record_date"
    t.decimal "record_value", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["annual_leave_id"], name: "index_refinery_annual_leave_records_on_annual_leave_id"
    t.index ["employee_id"], name: "index_refinery_annual_leave_records_on_employee_id"
    t.index ["record_date"], name: "index_refinery_annual_leave_records_on_record_date"
    t.index ["record_type"], name: "index_refinery_annual_leave_records_on_record_type"
  end

  create_table "refinery_annual_leaves", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "employee_id"
    t.integer "event_id"
    t.date "start_date"
    t.boolean "start_half_day", default: false, null: false
    t.date "end_date"
    t.boolean "end_half_day", default: false, null: false
    t.decimal "number_of_days", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_refinery_annual_leaves_on_employee_id"
    t.index ["end_date"], name: "index_refinery_annual_leaves_on_end_date"
    t.index ["event_id"], name: "index_refinery_annual_leaves_on_event_id"
    t.index ["start_date"], name: "index_refinery_annual_leaves_on_start_date"
  end

  create_table "refinery_authentication_devise_roles", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
  end

  create_table "refinery_authentication_devise_roles_users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id", "user_id"], name: "refinery_roles_users_role_id_user_id"
    t.index ["user_id", "role_id"], name: "refinery_roles_users_user_id_role_id"
  end

  create_table "refinery_authentication_devise_user_plugins", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.string "name"
    t.integer "position"
    t.index ["name"], name: "index_refinery_authentication_devise_user_plugins_on_name"
    t.index ["user_id", "name"], name: "refinery_user_plugins_user_id_name", unique: true
  end

  create_table "refinery_authentication_devise_users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "sign_in_count"
    t.datetime "remember_created_at"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.datetime "password_changed_at"
    t.string "full_name"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.integer "invitations_count", default: 0
    t.boolean "deactivated", default: false, null: false
    t.string "topo_id"
    t.datetime "last_active_at"
    t.string "first_name"
    t.string "last_name"
    t.index ["full_name"], name: "index_refinery_authentication_devise_users_on_full_name"
    t.index ["id"], name: "index_refinery_authentication_devise_users_on_id"
    t.index ["invitation_token"], name: "index_refinery_authentication_devise_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_refinery_authentication_devise_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_refinery_authentication_devise_users_on_invited_by_id"
    t.index ["last_active_at"], name: "index_refinery_authentication_devise_users_on_last_active_at"
    t.index ["password_changed_at"], name: "refinery_devise_users_password_changed_at"
    t.index ["slug"], name: "index_refinery_authentication_devise_users_on_slug"
    t.index ["topo_id"], name: "index_refinery_authentication_devise_users_on_topo_id"
  end

  create_table "refinery_blog_categories", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug"
    t.index ["id"], name: "index_refinery_blog_categories_on_id"
    t.index ["slug"], name: "index_refinery_blog_categories_on_slug"
  end

  create_table "refinery_blog_categories_blog_posts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "blog_category_id"
    t.integer "blog_post_id"
    t.index ["blog_category_id", "blog_post_id"], name: "index_blog_categories_blog_posts_on_bc_and_bp"
  end

  create_table "refinery_blog_category_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "refinery_blog_category_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "slug"
    t.index ["locale"], name: "index_refinery_blog_category_translations_on_locale"
    t.index ["refinery_blog_category_id"], name: "index_a0315945e6213bbe0610724da0ee2de681b77c31"
  end

  create_table "refinery_blog_comments", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "blog_post_id"
    t.boolean "spam"
    t.string "name"
    t.string "email"
    t.text "body"
    t.string "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["blog_post_id"], name: "index_refinery_blog_comments_on_blog_post_id"
    t.index ["id"], name: "index_refinery_blog_comments_on_id"
  end

  create_table "refinery_blog_post_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "refinery_blog_post_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body"
    t.text "custom_teaser"
    t.string "custom_url"
    t.string "slug"
    t.string "title"
    t.index ["locale"], name: "index_refinery_blog_post_translations_on_locale"
    t.index ["refinery_blog_post_id"], name: "index_refinery_blog_post_translations_on_refinery_blog_post_id"
  end

  create_table "refinery_blog_posts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.text "body"
    t.boolean "draft"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.string "custom_url"
    t.text "custom_teaser"
    t.string "source_url"
    t.string "source_url_title"
    t.integer "access_count", default: 0
    t.string "slug"
    t.string "username"
    t.index ["access_count"], name: "index_refinery_blog_posts_on_access_count"
    t.index ["id"], name: "index_refinery_blog_posts_on_id"
    t.index ["slug"], name: "index_refinery_blog_posts_on_slug"
  end

  create_table "refinery_brand_shows", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "brand_id"
    t.integer "show_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_refinery_brand_shows_on_brand_id"
    t.index ["show_id"], name: "index_refinery_brand_shows_on_show_id"
  end

  create_table "refinery_brands", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "website"
    t.integer "logo_id"
    t.text "description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refinery_business_accounts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "organisation"
    t.text "key_content"
    t.string "consumer_key"
    t.string "consumer_secret"
    t.string "encryption_key"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "bank_details"
    t.index ["organisation"], name: "index_refinery_business_accounts_on_organisation"
    t.index ["position"], name: "index_refinery_business_accounts_on_position"
  end

  create_table "refinery_business_articles", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "item_id"
    t.string "code"
    t.string "name"
    t.text "description"
    t.boolean "is_sold", default: false, null: false
    t.boolean "is_purchased", default: false, null: false
    t.boolean "is_public", default: false, null: false
    t.integer "company_id"
    t.boolean "is_managed", default: false, null: false
    t.datetime "updated_date_utc"
    t.string "managed_status"
    t.datetime "archived_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_voucher", default: false, null: false
    t.text "voucher_constraint"
    t.integer "account_id"
    t.decimal "purchase_unit_price", precision: 13, scale: 4, default: "0.0", null: false
    t.decimal "sales_unit_price", precision: 13, scale: 4, default: "0.0", null: false
    t.index ["account_id"], name: "index_refinery_business_articles_on_account_id"
    t.index ["archived_at"], name: "index_refinery_business_articles_on_archived_at"
    t.index ["code"], name: "index_refinery_business_articles_on_code"
    t.index ["company_id"], name: "index_refinery_business_articles_on_company_id"
    t.index ["is_managed"], name: "index_refinery_business_articles_on_is_managed"
    t.index ["is_public"], name: "index_refinery_business_articles_on_is_public"
    t.index ["is_purchased"], name: "index_refinery_business_articles_on_is_purchased"
    t.index ["is_sold"], name: "index_refinery_business_articles_on_is_sold"
    t.index ["is_voucher"], name: "index_refinery_business_articles_on_is_voucher"
    t.index ["item_id"], name: "index_refinery_business_articles_on_item_id"
    t.index ["managed_status"], name: "index_refinery_business_articles_on_managed_status"
    t.index ["name"], name: "index_refinery_business_articles_on_name"
    t.index ["updated_date_utc"], name: "index_refinery_business_articles_on_updated_date_utc"
  end

  create_table "refinery_business_billables", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "company_id"
    t.integer "project_id"
    t.integer "section_id"
    t.integer "invoice_id"
    t.string "billable_type"
    t.string "status"
    t.string "title"
    t.text "description"
    t.string "article_code"
    t.decimal "qty", precision: 10
    t.string "qty_unit"
    t.decimal "unit_price", precision: 13, scale: 4, default: "0.0", null: false
    t.decimal "discount", precision: 12, scale: 6, default: "0.0", null: false
    t.decimal "total_cost", precision: 13, scale: 4, default: "0.0", null: false
    t.string "account"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "billable_date"
    t.integer "assigned_to_id"
    t.string "assigned_to_label"
    t.datetime "archived_at"
    t.integer "article_id"
    t.integer "line_item_sales_id"
    t.integer "line_item_discount_id"
    t.index ["account"], name: "index_refinery_business_billables_on_account"
    t.index ["archived_at"], name: "INDEX_rb_billables_ON_archived_at"
    t.index ["article_code"], name: "index_refinery_business_billables_on_article_code"
    t.index ["article_id"], name: "INDEX_rb_billables_ON_article_id"
    t.index ["assigned_to_id"], name: "INDEX_rb_billables_ON_assigned_to_id"
    t.index ["assigned_to_label"], name: "INDEX_rb_billables_ON_assigned_to_label"
    t.index ["billable_date"], name: "index_refinery_business_billables_on_billable_date"
    t.index ["billable_type"], name: "index_refinery_business_billables_on_billable_type"
    t.index ["company_id"], name: "index_refinery_business_billables_on_company_id"
    t.index ["invoice_id"], name: "index_refinery_business_billables_on_invoice_id"
    t.index ["line_item_discount_id"], name: "INDEX_rb_billables_ON_line_item_discount_id"
    t.index ["line_item_sales_id"], name: "INDEX_rb_billables_ON_line_item_sales_id"
    t.index ["project_id"], name: "index_refinery_business_billables_on_project_id"
    t.index ["qty"], name: "index_refinery_business_billables_on_qty"
    t.index ["qty_unit"], name: "index_refinery_business_billables_on_qty_unit"
    t.index ["section_id"], name: "index_refinery_business_billables_on_section_id"
    t.index ["status"], name: "index_refinery_business_billables_on_status"
    t.index ["title"], name: "index_refinery_business_billables_on_title"
    t.index ["total_cost"], name: "index_refinery_business_billables_on_total_cost"
    t.index ["unit_price"], name: "index_refinery_business_billables_on_unit_price"
  end

  create_table "refinery_business_budget_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "budget_id"
    t.string "description"
    t.integer "no_of_products", default: 0, null: false
    t.integer "no_of_skus", default: 0, null: false
    t.decimal "price", precision: 8, scale: 2, default: "0.0", null: false
    t.integer "quantity", default: 0, null: false
    t.decimal "margin", precision: 6, scale: 5, default: "0.0", null: false
    t.text "comments", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_id"], name: "index_refinery_business_budget_items_on_budget_id"
  end

  create_table "refinery_business_budgets", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "description", default: "", null: false
    t.string "customer_name", default: "", null: false
    t.integer "customer_contact_id"
    t.date "from_date"
    t.date "to_date"
    t.string "account_manager_name", default: "", null: false
    t.integer "account_manager_user_id"
    t.integer "no_of_products", default: 0, null: false
    t.integer "no_of_skus", default: 0, null: false
    t.decimal "price", precision: 8, scale: 2, default: "0.0", null: false
    t.integer "quantity", default: 0, null: false
    t.decimal "margin", precision: 6, scale: 5, default: "0.0", null: false
    t.text "comments"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "margin_total", precision: 8, scale: 2, default: "0.0", null: false
    t.index ["account_manager_user_id"], name: "index_refinery_business_budgets_on_account_manager_user_id"
    t.index ["customer_contact_id"], name: "index_refinery_business_budgets_on_customer_contact_id"
    t.index ["description"], name: "index_refinery_business_budgets_on_description"
  end

  create_table "refinery_business_companies", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "contact_id"
    t.string "code"
    t.string "name"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "country_code"
    t.string "city"
    t.datetime "verified_at"
    t.integer "verified_by_id"
    t.index ["city"], name: "index_refinery_business_companies_on_city"
    t.index ["code"], name: "index_refinery_business_companies_on_code"
    t.index ["contact_id"], name: "index_refinery_business_companies_on_contact_id"
    t.index ["country_code"], name: "index_refinery_business_companies_on_country_code"
    t.index ["name"], name: "index_refinery_business_companies_on_name"
    t.index ["position"], name: "index_refinery_business_companies_on_position"
    t.index ["verified_at"], name: "index_refinery_business_companies_on_verified_at"
    t.index ["verified_by_id"], name: "index_refinery_business_companies_on_verified_by_id"
  end

  create_table "refinery_business_company_users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "company_id"
    t.integer "user_id"
    t.string "role"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["company_id"], name: "index_refinery_business_company_users_on_company_id"
    t.index ["position"], name: "index_refinery_business_company_users_on_position"
    t.index ["role"], name: "index_refinery_business_company_users_on_role"
    t.index ["user_id"], name: "index_refinery_business_company_users_on_user_id"
  end

  create_table "refinery_business_documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "company_id"
    t.integer "resource_id"
    t.string "document_type"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "request_id"
    t.text "meta", limit: 4294967295
    t.index ["company_id"], name: "index_refinery_business_documents_on_company_id"
    t.index ["document_type"], name: "index_refinery_business_documents_on_document_type"
    t.index ["request_id"], name: "index_refinery_business_documents_on_request_id"
    t.index ["resource_id"], name: "index_refinery_business_documents_on_resource_id"
  end

  create_table "refinery_business_invoice_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "invoice_id"
    t.string "line_item_id"
    t.string "description"
    t.decimal "quantity", precision: 13, scale: 4
    t.decimal "unit_amount", precision: 13, scale: 4
    t.string "item_code"
    t.string "account_code"
    t.string "tax_type"
    t.decimal "tax_amount", precision: 13, scale: 4
    t.decimal "line_amount", precision: 13, scale: 4
    t.integer "billable_id"
    t.string "transaction_type"
    t.integer "line_item_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_code"], name: "INDEX_rb_invoice_items_ON_account_code"
    t.index ["billable_id"], name: "INDEX_rb_invoice_items_ON_billable_id"
    t.index ["description"], name: "INDEX_rb_invoice_items_ON_description"
    t.index ["invoice_id"], name: "INDEX_rb_invoice_items_ON_invoice_id"
    t.index ["item_code"], name: "INDEX_rb_invoice_items_ON_item_code"
    t.index ["line_item_id"], name: "INDEX_rb_invoice_items_ON_line_item_id"
    t.index ["line_item_order"], name: "INDEX_rb_invoice_items_ON_line_item_order"
    t.index ["tax_type"], name: "INDEX_rb_invoice_items_ON_tax_type"
    t.index ["transaction_type"], name: "INDEX_rb_invoice_items_ON_transaction_type"
  end

  create_table "refinery_business_invoices", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "account_id"
    t.string "invoice_id"
    t.string "contact_id"
    t.string "invoice_number"
    t.string "invoice_type"
    t.string "reference"
    t.string "invoice_url"
    t.date "invoice_date"
    t.date "due_date"
    t.string "status"
    t.decimal "total_amount", precision: 12, scale: 2, default: "0.0"
    t.decimal "amount_due", precision: 12, scale: 2, default: "0.0"
    t.decimal "amount_paid", precision: 12, scale: 2, default: "0.0"
    t.decimal "amount_credited", precision: 8, scale: 2, default: "0.0"
    t.string "currency_code"
    t.decimal "currency_rate", precision: 12, scale: 6, default: "1.0"
    t.datetime "updated_date_utc"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "company_id"
    t.integer "project_id"
    t.integer "from_company_id"
    t.string "from_company_label"
    t.integer "from_contact_id"
    t.integer "to_company_id"
    t.string "to_company_label"
    t.integer "to_contact_id"
    t.datetime "archived_at"
    t.string "managed_status"
    t.boolean "is_managed", default: false, null: false
    t.date "invoice_for_month"
    t.text "plan_details"
    t.string "buyer_reference"
    t.string "seller_reference"
    t.index ["account_id"], name: "index_refinery_business_invoices_on_account_id"
    t.index ["archived_at"], name: "INDEX_rb_invoices_ON_archived_at"
    t.index ["buyer_reference"], name: "INDEX_rb_invoices_ON_buyer_reference"
    t.index ["company_id"], name: "index_refinery_business_invoices_on_company_id"
    t.index ["contact_id"], name: "index_refinery_business_invoices_on_contact_id"
    t.index ["from_company_id"], name: "INDEX_rb_invoices_ON_from_company_id"
    t.index ["from_company_label"], name: "INDEX_rb_invoices_ON_from_company_label"
    t.index ["from_contact_id"], name: "INDEX_rb_invoices_ON_from_contact_id"
    t.index ["invoice_date"], name: "index_refinery_business_invoices_on_invoice_date"
    t.index ["invoice_for_month"], name: "INDEX_rb_invoices_ON_invoice_for_month"
    t.index ["invoice_id"], name: "index_refinery_business_invoices_on_invoice_id"
    t.index ["invoice_number"], name: "index_refinery_business_invoices_on_invoice_number"
    t.index ["invoice_type"], name: "index_refinery_business_invoices_on_invoice_type"
    t.index ["is_managed"], name: "INDEX_rb_invoices_ON_is_managed"
    t.index ["managed_status"], name: "INDEX_rb_invoices_ON_managed_status"
    t.index ["position"], name: "index_refinery_business_invoices_on_position"
    t.index ["project_id"], name: "index_refinery_business_invoices_on_project_id"
    t.index ["seller_reference"], name: "INDEX_rb_invoices_ON_seller_reference"
    t.index ["status"], name: "index_refinery_business_invoices_on_status"
    t.index ["to_company_id"], name: "INDEX_rb_invoices_ON_to_company_id"
    t.index ["to_company_label"], name: "INDEX_rb_invoices_ON_to_company_label"
    t.index ["to_contact_id"], name: "INDEX_rb_invoices_ON_to_contact_id"
    t.index ["total_amount"], name: "index_refinery_business_invoices_on_total_amount"
  end

  create_table "refinery_business_number_series", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "identifier"
    t.integer "last_counter"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "prefix", default: "", null: false
    t.string "suffix", default: "", null: false
    t.integer "number_of_digits", default: 5, null: false
    t.index ["identifier"], name: "index_refinery_business_number_series_on_identifier"
    t.index ["last_counter"], name: "index_refinery_business_number_series_on_last_counter"
    t.index ["position"], name: "index_refinery_business_number_series_on_position"
  end

  create_table "refinery_business_order_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "order_id"
    t.string "order_item_id"
    t.integer "line_item_number"
    t.integer "article_id"
    t.string "article_code"
    t.string "description"
    t.decimal "ordered_qty", precision: 13, scale: 4, default: "0.0", null: false
    t.decimal "shipped_qty", precision: 13, scale: 4
    t.string "qty_unit"
    t.decimal "unit_price", precision: 13, scale: 4, default: "0.0", null: false
    t.decimal "discount", precision: 12, scale: 6, default: "0.0", null: false
    t.decimal "total_cost", precision: 13, scale: 4, default: "0.0", null: false
    t.string "account"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account"], name: "index_refinery_business_order_items_on_account"
    t.index ["article_code"], name: "index_refinery_business_order_items_on_article_code"
    t.index ["article_id"], name: "index_refinery_business_order_items_on_article_id"
    t.index ["line_item_number"], name: "index_refinery_business_order_items_on_line_item_number"
    t.index ["order_id"], name: "index_refinery_business_order_items_on_order_id"
    t.index ["order_item_id"], name: "index_refinery_business_order_items_on_order_item_id"
    t.index ["ordered_qty"], name: "index_refinery_business_order_items_on_ordered_qty"
    t.index ["qty_unit"], name: "index_refinery_business_order_items_on_qty_unit"
    t.index ["shipped_qty"], name: "index_refinery_business_order_items_on_shipped_qty"
    t.index ["total_cost"], name: "index_refinery_business_order_items_on_total_cost"
    t.index ["unit_price"], name: "index_refinery_business_order_items_on_unit_price"
  end

  create_table "refinery_business_orders", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "order_id"
    t.integer "buyer_id"
    t.string "buyer_label"
    t.integer "seller_id"
    t.string "seller_label"
    t.integer "project_id"
    t.string "order_number"
    t.string "order_type"
    t.date "order_date"
    t.integer "version_number"
    t.date "revised_date"
    t.string "reference"
    t.text "description"
    t.date "delivery_date"
    t.text "delivery_address"
    t.text "delivery_instructions"
    t.string "ship_mode"
    t.string "shipment_terms"
    t.string "attention_to"
    t.string "status"
    t.string "proforma_invoice_label"
    t.string "invoice_label"
    t.decimal "ordered_qty", precision: 13, scale: 4, default: "0.0", null: false
    t.decimal "shipped_qty", precision: 13, scale: 4
    t.string "qty_unit"
    t.string "currency_code"
    t.decimal "total_cost", precision: 13, scale: 4, default: "0.0", null: false
    t.string "account"
    t.datetime "updated_date_utc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account"], name: "index_refinery_business_orders_on_account"
    t.index ["attention_to"], name: "index_refinery_business_orders_on_attention_to"
    t.index ["buyer_id"], name: "index_refinery_business_orders_on_buyer_id"
    t.index ["buyer_label"], name: "index_refinery_business_orders_on_buyer_label"
    t.index ["currency_code"], name: "index_refinery_business_orders_on_currency_code"
    t.index ["delivery_date"], name: "index_refinery_business_orders_on_delivery_date"
    t.index ["invoice_label"], name: "index_refinery_business_orders_on_invoice_label"
    t.index ["order_date"], name: "index_refinery_business_orders_on_order_date"
    t.index ["order_id"], name: "index_refinery_business_orders_on_order_id"
    t.index ["order_number"], name: "index_refinery_business_orders_on_order_number"
    t.index ["order_type"], name: "index_refinery_business_orders_on_order_type"
    t.index ["ordered_qty"], name: "index_refinery_business_orders_on_ordered_qty"
    t.index ["proforma_invoice_label"], name: "index_refinery_business_orders_on_proforma_invoice_label"
    t.index ["project_id"], name: "index_refinery_business_orders_on_project_id"
    t.index ["qty_unit"], name: "index_refinery_business_orders_on_qty_unit"
    t.index ["reference"], name: "index_refinery_business_orders_on_reference"
    t.index ["revised_date"], name: "index_refinery_business_orders_on_revised_date"
    t.index ["seller_id"], name: "index_refinery_business_orders_on_seller_id"
    t.index ["seller_label"], name: "index_refinery_business_orders_on_seller_label"
    t.index ["ship_mode"], name: "index_refinery_business_orders_on_ship_mode"
    t.index ["shipment_terms"], name: "index_refinery_business_orders_on_shipment_terms"
    t.index ["shipped_qty"], name: "index_refinery_business_orders_on_shipped_qty"
    t.index ["status"], name: "index_refinery_business_orders_on_status"
    t.index ["total_cost"], name: "index_refinery_business_orders_on_total_cost"
    t.index ["updated_date_utc"], name: "index_refinery_business_orders_on_updated_date_utc"
    t.index ["version_number"], name: "index_refinery_business_orders_on_version_number"
  end

  create_table "refinery_business_plans", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "company_id"
    t.integer "contract_id"
    t.string "reference"
    t.string "title"
    t.text "description"
    t.date "start_date"
    t.date "end_date"
    t.string "status"
    t.datetime "confirmed_at"
    t.integer "confirmed_by_id"
    t.integer "payment_terms_days", default: 0, null: false
    t.integer "notice_period_months", default: 0, null: false
    t.integer "min_contract_period_months", default: 0, null: false
    t.datetime "notice_given_at"
    t.integer "notice_given_by_id"
    t.text "content"
    t.text "meta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.string "currency_code"
    t.integer "contact_person_id"
    t.integer "account_manager_id"
    t.text "payment_terms_content"
    t.index ["account_id"], name: "index_refinery_business_plans_on_account_id"
    t.index ["account_manager_id"], name: "index_refinery_business_plans_on_account_manager_id"
    t.index ["company_id"], name: "index_refinery_business_plans_on_company_id"
    t.index ["confirmed_at"], name: "index_refinery_business_plans_on_confirmed_at"
    t.index ["confirmed_by_id"], name: "index_refinery_business_plans_on_confirmed_by_id"
    t.index ["contact_person_id"], name: "index_refinery_business_plans_on_contact_person_id"
    t.index ["currency_code"], name: "index_refinery_business_plans_on_currency_code"
    t.index ["end_date"], name: "index_refinery_business_plans_on_end_date"
    t.index ["notice_given_at"], name: "index_refinery_business_plans_on_notice_given_at"
    t.index ["notice_given_by_id"], name: "index_refinery_business_plans_on_notice_given_by_id"
    t.index ["reference"], name: "index_refinery_business_plans_on_reference"
    t.index ["start_date"], name: "index_refinery_business_plans_on_start_date"
    t.index ["status"], name: "index_refinery_business_plans_on_status"
    t.index ["title"], name: "index_refinery_business_plans_on_title"
  end

  create_table "refinery_business_projects", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "company_id"
    t.string "code"
    t.text "description"
    t.string "status"
    t.date "start_date"
    t.date "end_date"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "company_reference"
    t.index ["code"], name: "index_refinery_business_projects_on_code"
    t.index ["company_id"], name: "index_refinery_business_projects_on_company_id"
    t.index ["company_reference"], name: "index_refinery_business_projects_on_company_reference"
    t.index ["end_date"], name: "index_refinery_business_projects_on_end_date"
    t.index ["position"], name: "index_refinery_business_projects_on_position"
    t.index ["start_date"], name: "index_refinery_business_projects_on_start_date"
    t.index ["status"], name: "index_refinery_business_projects_on_status"
  end

  create_table "refinery_business_purchases", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "company_id"
    t.string "status"
    t.string "stripe_checkout_session_id"
    t.string "stripe_payment_intent_id"
    t.string "stripe_event_id"
    t.string "discount_code"
    t.decimal "sub_total_cost", precision: 13, scale: 4, default: "0.0", null: false
    t.decimal "total_discount", precision: 13, scale: 4, default: "0.0", null: false
    t.decimal "total_cost", precision: 13, scale: 4, default: "0.0", null: false
    t.text "meta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_refinery_business_purchases_on_company_id"
    t.index ["discount_code"], name: "index_refinery_business_purchases_on_discount_code"
    t.index ["status"], name: "index_refinery_business_purchases_on_status"
    t.index ["stripe_checkout_session_id"], name: "index_refinery_business_purchases_on_stripe_checkout_session_id"
    t.index ["stripe_event_id"], name: "index_refinery_business_purchases_on_stripe_event_id"
    t.index ["stripe_payment_intent_id"], name: "index_refinery_business_purchases_on_stripe_payment_intent_id"
    t.index ["user_id"], name: "index_refinery_business_purchases_on_user_id"
  end

  create_table "refinery_business_requests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "code"
    t.integer "company_id"
    t.integer "created_by_id"
    t.integer "requested_by_id"
    t.string "participants"
    t.string "request_type"
    t.string "status"
    t.string "subject"
    t.date "request_date"
    t.text "description"
    t.text "comments"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["archived_at"], name: "index_refinery_business_requests_on_archived_at"
    t.index ["code"], name: "index_refinery_business_requests_on_code"
    t.index ["company_id"], name: "index_refinery_business_requests_on_company_id"
    t.index ["created_by_id"], name: "index_refinery_business_requests_on_created_by_id"
    t.index ["participants"], name: "index_refinery_business_requests_on_participants"
    t.index ["request_date"], name: "index_refinery_business_requests_on_request_date"
    t.index ["request_type"], name: "index_refinery_business_requests_on_request_type"
    t.index ["requested_by_id"], name: "index_refinery_business_requests_on_requested_by_id"
    t.index ["status"], name: "index_refinery_business_requests_on_status"
    t.index ["subject"], name: "index_refinery_business_requests_on_subject"
  end

  create_table "refinery_business_sections", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "project_id"
    t.string "section_type"
    t.text "description"
    t.date "start_date"
    t.date "end_date"
    t.string "budgeted_resources"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["end_date"], name: "index_refinery_business_sections_on_end_date"
    t.index ["position"], name: "index_refinery_business_sections_on_position"
    t.index ["project_id"], name: "index_refinery_business_sections_on_project_id"
    t.index ["section_type"], name: "index_refinery_business_sections_on_section_type"
    t.index ["start_date"], name: "index_refinery_business_sections_on_start_date"
  end

  create_table "refinery_business_vouchers", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "company_id"
    t.integer "article_id"
    t.integer "line_item_sales_purchase_id"
    t.integer "line_item_sales_discount_id"
    t.integer "line_item_sales_move_from_id"
    t.integer "line_item_prepay_move_to_id"
    t.integer "line_item_prepay_move_from_id"
    t.integer "line_item_sales_move_to_id"
    t.string "discount_type"
    t.decimal "base_amount", precision: 13, scale: 4
    t.decimal "discount_amount", precision: 13, scale: 4
    t.decimal "discount_percentage", precision: 9, scale: 6
    t.decimal "amount", precision: 13, scale: 4
    t.string "currency_code"
    t.datetime "valid_from"
    t.datetime "valid_to"
    t.string "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "code"
    t.string "source"
    t.index ["article_id"], name: "INDEX_rb_vouchers_ON_article_id"
    t.index ["code"], name: "INDEX_rb_vouchers_ON_code"
    t.index ["company_id"], name: "INDEX_rb_vouchers_ON_company_id"
    t.index ["currency_code"], name: "INDEX_rb_vouchers_ON_currency_code"
    t.index ["discount_type"], name: "INDEX_rb_vouchers_ON_disount_type"
    t.index ["line_item_prepay_move_from_id"], name: "INDEX_rb_vouchers_ON_line_item_prepay_move_from_id"
    t.index ["line_item_prepay_move_to_id"], name: "INDEX_rb_vouchers_ON_line_item_prepay_move_to_id"
    t.index ["line_item_sales_discount_id"], name: "INDEX_rb_vouchers_ON_line_item_sales_discount_id"
    t.index ["line_item_sales_move_from_id"], name: "INDEX_rb_vouchers_ON_line_item_sales_move_from_id"
    t.index ["line_item_sales_move_to_id"], name: "INDEX_rb_vouchers_ON_line_item_sales_move_to_id"
    t.index ["line_item_sales_purchase_id"], name: "INDEX_rb_vouchers_ON_line_item_sales_purchase_id"
    t.index ["source"], name: "index_refinery_business_vouchers_on_source"
    t.index ["status"], name: "INDEX_rb_vouchers_ON_status"
    t.index ["valid_from"], name: "INDEX_rb_vouchers_ON_valid_from"
    t.index ["valid_to"], name: "INDEX_rb_vouchers_ON_valid_to"
  end

  create_table "refinery_calendar_calendars", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "function"
    t.integer "user_id"
    t.boolean "private", default: false, null: false
    t.string "default_rgb_code"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["function"], name: "index_refinery_calendar_calendars_on_function"
    t.index ["position"], name: "index_refinery_calendar_calendars_on_position"
    t.index ["private"], name: "index_refinery_calendar_calendars_on_private"
    t.index ["user_id"], name: "index_refinery_calendar_calendars_on_user_id"
  end

  create_table "refinery_calendar_events", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "registration_link"
    t.string "excerpt"
    t.text "description"
    t.integer "position"
    t.boolean "featured"
    t.string "slug"
    t.integer "venue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer "calendar_id"
    t.index ["calendar_id"], name: "index_refinery_calendar_events_on_calendar_id"
  end

  create_table "refinery_calendar_google_calendars", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "primary_calendar_id"
    t.string "google_calendar_id"
    t.string "refresh_token"
    t.integer "sync_to_id", default: 0, null: false
    t.integer "sync_from_id", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["google_calendar_id"], name: "index_rcgc_on_google_calendar_id"
    t.index ["primary_calendar_id"], name: "index_rcgc_on_primary_calendar_id"
    t.index ["user_id"], name: "index_rcgc_on_user_id"
  end

  create_table "refinery_calendar_google_events", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "google_calendar_id"
    t.integer "event_id"
    t.string "google_event_id"
    t.datetime "last_synced_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_rcge_on_event_id"
    t.index ["google_calendar_id"], name: "index_rcge_on_google_calendar_id"
    t.index ["google_event_id"], name: "index_rcge_on_google_event_id"
  end

  create_table "refinery_calendar_user_calendars", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "calendar_id"
    t.boolean "inactive", default: false, null: false
    t.string "rgb_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_refinery_calendar_user_calendars_on_calendar_id"
    t.index ["inactive"], name: "index_refinery_calendar_user_calendars_on_inactive"
    t.index ["user_id"], name: "index_refinery_calendar_user_calendars_on_user_id"
  end

  create_table "refinery_calendar_venues", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "address"
    t.string "url"
    t.string "phone"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refinery_contacts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "base_id"
    t.string "name"
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "city"
    t.string "skype"
    t.string "zip"
    t.string "country"
    t.string "title"
    t.boolean "private"
    t.integer "contact_id"
    t.boolean "is_organisation"
    t.string "mobile"
    t.string "fax"
    t.string "website"
    t.string "phone"
    t.text "description"
    t.string "linked_in"
    t.string "facebook"
    t.string "industry"
    t.string "twitter"
    t.string "email"
    t.string "organisation_name"
    t.integer "organisation_id"
    t.string "tags_joined_by_comma"
    t.boolean "is_sales_account"
    t.string "customer_status"
    t.string "prospect_status"
    t.datetime "base_modified_at"
    t.text "custom_fields"
    t.integer "position"
    t.boolean "removed_from_base", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "state"
    t.integer "insightly_id"
    t.string "courier_company"
    t.string "courier_account_no"
    t.string "image_url"
    t.string "code"
    t.string "xero_hr_id"
    t.string "xero_hrt_id"
    t.string "mailchimp_id"
    t.string "other_address"
    t.string "other_city"
    t.string "other_zip"
    t.string "other_state"
    t.string "other_country"
    t.integer "image_id"
    t.integer "owner_id"
    t.index ["base_id"], name: "index_refinery_contacts_on_base_id"
    t.index ["base_modified_at"], name: "index_refinery_contacts_on_base_modified_at"
    t.index ["code"], name: "index_refinery_contacts_on_code"
    t.index ["courier_company"], name: "index_refinery_contacts_on_courier_company"
    t.index ["image_id"], name: "index_refinery_contacts_on_image_id"
    t.index ["insightly_id"], name: "index_refinery_contacts_on_insightly_id"
    t.index ["mailchimp_id"], name: "index_refinery_contacts_on_mailchimp_id"
    t.index ["organisation_id"], name: "index_refinery_contacts_on_organisation_id"
    t.index ["owner_id"], name: "index_refinery_contacts_on_owner_id"
    t.index ["removed_from_base"], name: "index_refinery_contacts_on_removed_from_base"
    t.index ["state"], name: "index_refinery_contacts_on_state"
    t.index ["user_id"], name: "index_refinery_contacts_on_user_id"
    t.index ["xero_hr_id"], name: "index_refinery_contacts_on_xero_hr_id"
    t.index ["xero_hrt_id"], name: "index_refinery_contacts_on_xero_hrt_id"
  end

  create_table "refinery_custom_lists_custom_lists", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refinery_custom_lists_list_cells", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "list_row_id"
    t.integer "list_column_id"
    t.string "value"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_column_id"], name: "index_refinery_custom_lists_list_cells_on_list_column_id"
    t.index ["list_row_id"], name: "index_refinery_custom_lists_list_cells_on_list_row_id"
    t.index ["value"], name: "index_refinery_custom_lists_list_cells_on_value"
  end

  create_table "refinery_custom_lists_list_columns", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "custom_list_id"
    t.string "title"
    t.string "column_type"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_list_id"], name: "index_refinery_custom_lists_list_columns_on_custom_list_id"
    t.index ["position"], name: "index_refinery_custom_lists_list_columns_on_position"
  end

  create_table "refinery_custom_lists_list_rows", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "custom_list_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_list_id"], name: "index_refinery_custom_lists_list_rows_on_custom_list_id"
    t.index ["position"], name: "index_refinery_custom_lists_list_rows_on_position"
  end

  create_table "refinery_employees", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "profile_image_id"
    t.string "employee_no"
    t.string "full_name"
    t.string "id_no"
    t.string "title"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "xero_guid"
    t.text "default_tracking_options"
    t.integer "reporting_manager_id"
    t.integer "contact_id"
    t.string "emergency_contact"
    t.date "birthday"
    t.index ["birthday"], name: "index_refinery_employees_on_birthday"
    t.index ["contact_id"], name: "index_refinery_employees_on_contact_id"
    t.index ["employee_no"], name: "index_refinery_employees_on_employee_no"
    t.index ["position"], name: "index_refinery_employees_on_position"
    t.index ["profile_image_id"], name: "index_refinery_employees_on_profile_image_id"
    t.index ["reporting_manager_id"], name: "index_refinery_employees_on_reporting_manager_id"
    t.index ["user_id"], name: "index_refinery_employees_on_user_id"
  end

  create_table "refinery_employment_contracts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "employee_id", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.decimal "vacation_days_per_year", precision: 10, default: "0", null: false
    t.decimal "days_carried_over", precision: 10, scale: 2, default: "0.0", null: false
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_refinery_employment_contracts_on_employee_id"
    t.index ["end_date"], name: "index_refinery_employment_contracts_on_end_date"
    t.index ["start_date"], name: "index_refinery_employment_contracts_on_start_date"
  end

  create_table "refinery_image_page_translations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "refinery_image_page_id"
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "caption"
    t.index ["locale"], name: "index_refinery_image_page_translations_on_locale"
    t.index ["refinery_image_page_id"], name: "index_186c9a170a0ab319c675aa80880ce155d8f47244"
  end

  create_table "refinery_image_pages", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "image_id"
    t.integer "page_id"
    t.integer "position"
    t.text "caption"
    t.string "page_type", default: "page"
    t.index ["image_id"], name: "index_refinery_image_pages_on_image_id"
    t.index ["page_id"], name: "index_refinery_image_pages_on_page_id"
  end

  create_table "refinery_image_translations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "refinery_image_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_alt"
    t.string "image_title"
    t.index ["locale"], name: "index_refinery_image_translations_on_locale"
    t.index ["refinery_image_id"], name: "index_refinery_image_translations_on_refinery_image_id"
  end

  create_table "refinery_images", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "image_mime_type"
    t.string "image_name"
    t.integer "image_size"
    t.integer "image_width"
    t.integer "image_height"
    t.string "image_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_title"
    t.string "image_alt"
    t.string "authorizations_access"
    t.index ["authorizations_access"], name: "index_refinery_images_on_authorizations_access"
  end

  create_table "refinery_leave_of_absences", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "employee_id"
    t.integer "event_id"
    t.integer "doctors_note_id"
    t.integer "absence_type_id"
    t.string "absence_type_description"
    t.integer "status"
    t.date "start_date"
    t.boolean "start_half_day", default: false, null: false
    t.date "end_date"
    t.boolean "end_half_day", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["absence_type_id"], name: "index_refinery_leave_of_absences_on_absence_type_id"
    t.index ["doctors_note_id"], name: "index_refinery_leave_of_absences_on_doctors_note_id"
    t.index ["employee_id"], name: "index_refinery_leave_of_absences_on_employee_id"
    t.index ["end_date"], name: "index_refinery_leave_of_absences_on_end_date"
    t.index ["event_id"], name: "index_refinery_leave_of_absences_on_event_id"
    t.index ["start_date"], name: "index_refinery_leave_of_absences_on_start_date"
    t.index ["status"], name: "index_refinery_leave_of_absences_on_status"
  end

  create_table "refinery_news_item_translations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "refinery_news_item_id"
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "body"
    t.string "source"
    t.string "slug"
    t.index ["locale"], name: "index_refinery_news_item_translations_on_locale"
    t.index ["refinery_news_item_id"], name: "index_refinery_news_item_translations_fk"
  end

  create_table "refinery_news_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.text "body"
    t.datetime "publish_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "image_id"
    t.datetime "expiration_date"
    t.string "source"
    t.string "slug"
    t.index ["id"], name: "index_refinery_news_items_on_id"
  end

  create_table "refinery_page_part_translations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "refinery_page_part_id"
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body"
    t.index ["locale"], name: "index_refinery_page_part_translations_on_locale"
    t.index ["refinery_page_part_id"], name: "index_refinery_page_part_translations_on_refinery_page_part_id"
  end

  create_table "refinery_page_parts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "refinery_page_id"
    t.string "slug"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["id"], name: "index_refinery_page_parts_on_id"
    t.index ["refinery_page_id"], name: "index_refinery_page_parts_on_refinery_page_id"
  end

  create_table "refinery_page_roles", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "page_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id", "role_id"], name: "index_refinery_page_roles_on_page_id_and_role_id"
  end

  create_table "refinery_page_translations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "refinery_page_id"
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "custom_slug"
    t.string "menu_title"
    t.string "slug"
    t.index ["locale"], name: "index_refinery_page_translations_on_locale"
    t.index ["refinery_page_id"], name: "index_refinery_page_translations_on_refinery_page_id"
  end

  create_table "refinery_pages", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "parent_id"
    t.string "path"
    t.boolean "show_in_menu", default: true
    t.string "link_url"
    t.string "menu_match"
    t.boolean "deletable", default: true
    t.boolean "draft", default: false
    t.boolean "skip_to_first_child", default: false
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth"
    t.string "view_template"
    t.string "layout_template"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "children_count", default: 0, null: false
    t.index ["depth"], name: "index_refinery_pages_on_depth"
    t.index ["id"], name: "index_refinery_pages_on_id"
    t.index ["lft"], name: "index_refinery_pages_on_lft"
    t.index ["parent_id"], name: "index_refinery_pages_on_parent_id"
    t.index ["rgt"], name: "index_refinery_pages_on_rgt"
  end

  create_table "refinery_public_holidays", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "event_id"
    t.string "title"
    t.string "country"
    t.date "holiday_date", null: false
    t.boolean "half_day", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_refinery_public_holidays_on_event_id"
    t.index ["holiday_date"], name: "index_refinery_public_holidays_on_holiday_date"
  end

  create_table "refinery_quality_assurance_defects", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "category_code"
    t.string "category_name"
    t.integer "defect_code"
    t.string "defect_name"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["category_code"], name: "index_qa_defects_on_category_code"
    t.index ["category_name"], name: "index_qa_defects_on_category_name"
    t.index ["defect_code"], name: "index_qa_defects_on_defect_code"
    t.index ["defect_name"], name: "index_qa_defects_on_defect_name"
  end

  create_table "refinery_quality_assurance_inspection_defects", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "inspection_id"
    t.integer "defect_id"
    t.integer "critical", default: 0, null: false
    t.integer "major", default: 0, null: false
    t.integer "minor", default: 0, null: false
    t.string "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "defect_label"
    t.boolean "can_fix"
    t.index ["defect_id"], name: "index_qa_inspection_defects_on_defect_id"
    t.index ["inspection_id"], name: "index_qa_inspection_defects_on_inspection_id"
  end

  create_table "refinery_quality_assurance_inspection_photos", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "inspection_id"
    t.integer "inspection_defect_id"
    t.integer "image_id"
    t.string "file_id"
    t.text "fields"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["file_id"], name: "index_qa_inspection_photos_on_file_id"
    t.index ["image_id"], name: "index_qa_inspection_photos_on_image_id"
    t.index ["inspection_defect_id"], name: "index_qa_inspection_photos_on_inspection_defect_id"
    t.index ["inspection_id"], name: "index_qa_inspection_photos_on_inspection_id"
  end

  create_table "refinery_quality_assurance_inspections", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "company_id"
    t.integer "supplier_id"
    t.string "supplier_label"
    t.integer "business_section_id"
    t.integer "business_product_id"
    t.integer "assigned_to_id"
    t.integer "resource_id"
    t.integer "inspected_by_id"
    t.string "inspected_by_name"
    t.string "document_id"
    t.string "result"
    t.date "inspection_date"
    t.integer "inspection_sample_size"
    t.string "inspection_type"
    t.string "po_number"
    t.string "po_type"
    t.integer "po_qty"
    t.integer "available_qty"
    t.string "product_code"
    t.string "product_description"
    t.string "product_colour_variants"
    t.string "inspection_standard"
    t.integer "acc_critical"
    t.integer "acc_major"
    t.integer "acc_minor"
    t.integer "total_critical", default: 0, null: false
    t.integer "total_major", default: 0, null: false
    t.integer "total_minor", default: 0, null: false
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "fields"
    t.string "company_label"
    t.integer "inspection_photo_id"
    t.string "company_code"
    t.string "supplier_code"
    t.integer "manufacturer_id"
    t.string "manufacturer_label"
    t.string "manufacturer_code"
    t.string "status"
    t.string "company_project_reference"
    t.string "project_code"
    t.string "code"
    t.integer "job_id"
    t.string "product_category"
    t.string "season"
    t.string "brand_label"
    t.boolean "pps_available"
    t.boolean "pps_approved"
    t.text "pps_comments"
    t.boolean "tp_available"
    t.boolean "tp_approved"
    t.text "tp_comments"
    t.index ["assigned_to_id"], name: "index_qa_inspections_on_assigned_to_id"
    t.index ["brand_label"], name: "index_refinery_quality_assurance_inspections_on_brand_label"
    t.index ["business_product_id"], name: "index_qa_inspections_on_business_product_id"
    t.index ["business_section_id"], name: "index_qa_inspections_on_business_section_id"
    t.index ["code"], name: "index_refinery_quality_assurance_inspections_on_code"
    t.index ["company_code"], name: "index_qa_inspections_on_company_code"
    t.index ["company_id"], name: "index_qa_inspections_on_company_id"
    t.index ["company_project_reference"], name: "index_qa_inspections_on_company_project_reference"
    t.index ["document_id"], name: "index_qa_inspections_on_document_id"
    t.index ["inspection_date"], name: "index_qa_inspections_on_inspection_date"
    t.index ["inspection_photo_id"], name: "index_qa_inspections_on_inspection_photo_id"
    t.index ["inspection_type"], name: "index_qa_inspections_on_inspection_type"
    t.index ["job_id"], name: "index_qa_inspections_on_job_id"
    t.index ["manufacturer_code"], name: "index_qa_inspections_on_manufacturer_code"
    t.index ["manufacturer_id"], name: "index_qa_inspections_on_manufacturer_id"
    t.index ["manufacturer_label"], name: "index_qa_inspections_on_manufacturer_label"
    t.index ["po_number"], name: "index_qa_inspections_on_po_number"
    t.index ["po_qty"], name: "index_qa_inspections_on_po_qty"
    t.index ["po_type"], name: "index_qa_inspections_on_po_type"
    t.index ["position"], name: "index_qa_inspections_on_position"
    t.index ["pps_approved"], name: "index_refinery_quality_assurance_inspections_on_pps_approved"
    t.index ["pps_available"], name: "index_refinery_quality_assurance_inspections_on_pps_available"
    t.index ["product_category"], name: "index_refinery_quality_assurance_inspections_on_product_category"
    t.index ["product_code"], name: "index_qa_inspections_on_product_code"
    t.index ["product_description"], name: "index_qa_inspections_on_product_description"
    t.index ["project_code"], name: "index_refinery_quality_assurance_inspections_on_project_code"
    t.index ["resource_id"], name: "index_qa_inspections_on_resource_id"
    t.index ["result"], name: "index_qa_inspections_on_result"
    t.index ["season"], name: "index_refinery_quality_assurance_inspections_on_season"
    t.index ["status"], name: "index_refinery_quality_assurance_inspections_on_status"
    t.index ["supplier_code"], name: "index_qa_inspections_on_supplier_code"
    t.index ["supplier_id"], name: "index_qa_inspections_on_supplier_id"
    t.index ["tp_approved"], name: "index_refinery_quality_assurance_inspections_on_tp_approved"
    t.index ["tp_available"], name: "index_refinery_quality_assurance_inspections_on_tp_available"
  end

  create_table "refinery_quality_assurance_jobs", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "company_id"
    t.string "company_code"
    t.string "company_label"
    t.integer "project_id"
    t.string "project_code"
    t.string "company_project_reference"
    t.integer "section_id"
    t.string "billable_type"
    t.integer "billable_id"
    t.string "status"
    t.string "code"
    t.string "title"
    t.text "description"
    t.integer "assigned_to_id"
    t.string "assigned_to_label"
    t.string "job_type"
    t.date "inspection_date"
    t.decimal "time_spent", precision: 8, scale: 2, default: "0.0", null: false
    t.text "time_log"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["assigned_to_id"], name: "index_qa_inspection_jobs_on_assigned_to_id"
    t.index ["assigned_to_label"], name: "index_qa_inspection_jobs_on_assigned_to_label"
    t.index ["billable_id"], name: "index_qa_inspection_jobs_on_billable_id"
    t.index ["billable_type"], name: "index_qa_inspection_jobs_on_billable_type"
    t.index ["code"], name: "index_qa_inspection_jobs_on_code"
    t.index ["company_code"], name: "index_qa_inspection_jobs_on_company_code"
    t.index ["company_id"], name: "index_qa_inspection_jobs_on_company_id"
    t.index ["company_label"], name: "index_qa_inspection_jobs_on_company_label"
    t.index ["company_project_reference"], name: "index_qa_inspection_jobs_on_company_project_reference"
    t.index ["inspection_date"], name: "index_qa_inspection_jobs_on_inspection_date"
    t.index ["job_type"], name: "index_qa_inspection_jobs_on_job_type"
    t.index ["position"], name: "index_qa_inspection_jobs_on_position"
    t.index ["project_code"], name: "index_qa_inspection_jobs_on_project_code"
    t.index ["project_id"], name: "index_qa_inspection_jobs_on_project_id"
    t.index ["section_id"], name: "index_qa_inspection_jobs_on_section_id"
    t.index ["status"], name: "index_qa_inspection_jobs_on_status"
    t.index ["title"], name: "index_qa_inspection_jobs_on_title"
  end

  create_table "refinery_resource_translations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "refinery_resource_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "resource_title"
    t.index ["locale"], name: "index_refinery_resource_translations_on_locale"
    t.index ["refinery_resource_id"], name: "index_refinery_resource_translations_on_refinery_resource_id"
  end

  create_table "refinery_resources", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "file_mime_type"
    t.string "file_name"
    t.integer "file_size"
    t.string "file_uid"
    t.string "file_ext"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authorizations_access"
    t.index ["authorizations_access"], name: "index_refinery_resources_on_authorizations_access"
  end

  create_table "refinery_settings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "value"
    t.boolean "destroyable", default: true
    t.string "scoping"
    t.boolean "restricted", default: false
    t.string "form_value_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "title"
    t.index ["name"], name: "index_refinery_settings_on_name"
  end

  create_table "refinery_shipping_addresses", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "easy_post_id"
    t.string "name"
    t.string "company"
    t.string "street1"
    t.string "street2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.string "phone"
    t.string "email"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["easy_post_id"], name: "index_refinery_shipping_addresses_on_easy_post_id"
    t.index ["position"], name: "index_refinery_shipping_addresses_on_position"
  end

  create_table "refinery_shipping_costs", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "shipment_id"
    t.string "cost_type"
    t.text "comments"
    t.string "currency_code"
    t.decimal "amount", precision: 13, scale: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "invoice_amount", precision: 13, scale: 4
    t.index ["amount"], name: "index_refinery_shipping_costs_on_amount"
    t.index ["cost_type"], name: "index_refinery_shipping_costs_on_cost_type"
    t.index ["currency_code"], name: "index_refinery_shipping_costs_on_currency_code"
    t.index ["invoice_amount"], name: "index_refinery_shipping_costs_on_invoice_amount"
    t.index ["shipment_id"], name: "index_refinery_shipping_costs_on_shipment_id"
  end

  create_table "refinery_shipping_documents", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "shipment_id"
    t.integer "resource_id"
    t.string "document_type"
    t.text "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["document_type"], name: "index_refinery_shipping_documents_on_document_type"
    t.index ["resource_id"], name: "index_refinery_shipping_documents_on_resource_id"
    t.index ["shipment_id"], name: "index_refinery_shipping_documents_on_shipment_id"
  end

  create_table "refinery_shipping_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "shipment_id"
    t.integer "order_id"
    t.string "order_label"
    t.integer "order_item_id"
    t.string "article_code"
    t.string "description"
    t.string "hs_code_label"
    t.boolean "partial_shipment", default: false, null: false
    t.decimal "qty", precision: 13, scale: 4
    t.integer "item_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["article_code"], name: "index_refinery_shipping_items_on_article_code"
    t.index ["description"], name: "index_refinery_shipping_items_on_description"
    t.index ["hs_code_label"], name: "index_refinery_shipping_items_on_hs_code_label"
    t.index ["item_order"], name: "index_refinery_shipping_items_on_item_order"
    t.index ["order_id"], name: "index_refinery_shipping_items_on_order_id"
    t.index ["order_item_id"], name: "index_refinery_shipping_items_on_order_item_id"
    t.index ["order_label"], name: "index_refinery_shipping_items_on_order_label"
    t.index ["partial_shipment"], name: "index_refinery_shipping_items_on_partial_shipment"
    t.index ["shipment_id"], name: "index_refinery_shipping_items_on_shipment_id"
  end

  create_table "refinery_shipping_locations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "description"
    t.integer "owner_id"
    t.string "location_type"
    t.boolean "airport", default: false, null: false
    t.boolean "railport", default: false, null: false
    t.boolean "roadport", default: false, null: false
    t.boolean "seaport", default: false, null: false
    t.string "location_code"
    t.string "iata_code"
    t.string "icao_code"
    t.string "street1"
    t.string "street2"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.string "country_code"
    t.string "timezone"
    t.decimal "lat", precision: 9, scale: 6
    t.decimal "lng", precision: 9, scale: 6
    t.string "customs_district_code"
    t.datetime "confirmed_at"
    t.datetime "verified_at"
    t.datetime "archived_at"
    t.boolean "public", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["airport"], name: "index_refinery_shipping_locations_on_airport"
    t.index ["archived_at"], name: "index_refinery_shipping_locations_on_archived_at"
    t.index ["city"], name: "index_refinery_shipping_locations_on_city"
    t.index ["confirmed_at"], name: "index_refinery_shipping_locations_on_confirmed_at"
    t.index ["country"], name: "index_refinery_shipping_locations_on_country"
    t.index ["country_code"], name: "index_refinery_shipping_locations_on_country_code"
    t.index ["customs_district_code"], name: "index_refinery_shipping_locations_on_customs_district_code"
    t.index ["iata_code"], name: "index_refinery_shipping_locations_on_iata_code"
    t.index ["icao_code"], name: "index_refinery_shipping_locations_on_icao_code"
    t.index ["lat"], name: "index_refinery_shipping_locations_on_lat"
    t.index ["lng"], name: "index_refinery_shipping_locations_on_lng"
    t.index ["location_code"], name: "index_refinery_shipping_locations_on_location_code"
    t.index ["location_type"], name: "index_refinery_shipping_locations_on_location_type"
    t.index ["name"], name: "index_refinery_shipping_locations_on_name"
    t.index ["owner_id"], name: "index_refinery_shipping_locations_on_owner_id"
    t.index ["postal_code"], name: "index_refinery_shipping_locations_on_postal_code"
    t.index ["public"], name: "index_refinery_shipping_locations_on_public"
    t.index ["railport"], name: "index_refinery_shipping_locations_on_railport"
    t.index ["roadport"], name: "index_refinery_shipping_locations_on_roadport"
    t.index ["seaport"], name: "index_refinery_shipping_locations_on_seaport"
    t.index ["state"], name: "index_refinery_shipping_locations_on_state"
    t.index ["street1"], name: "index_refinery_shipping_locations_on_street1"
    t.index ["street2"], name: "index_refinery_shipping_locations_on_street2"
    t.index ["timezone"], name: "index_refinery_shipping_locations_on_timezone"
    t.index ["verified_at"], name: "index_refinery_shipping_locations_on_verified_at"
  end

  create_table "refinery_shipping_packages", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "shipment_id"
    t.string "name"
    t.string "package_type"
    t.decimal "total_packages", precision: 13, scale: 4
    t.string "length_unit"
    t.decimal "package_length", precision: 13, scale: 4
    t.decimal "package_width", precision: 13, scale: 4
    t.decimal "package_height", precision: 13, scale: 4
    t.string "volume_unit"
    t.decimal "package_volume", precision: 13, scale: 4
    t.string "weight_unit"
    t.decimal "package_gross_weight", precision: 13, scale: 4
    t.integer "package_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "package_net_weight", precision: 13, scale: 4
    t.index ["name"], name: "index_refinery_shipping_packages_on_name"
    t.index ["package_order"], name: "index_refinery_shipping_packages_on_package_order"
    t.index ["package_type"], name: "index_refinery_shipping_packages_on_package_type"
    t.index ["shipment_id"], name: "index_refinery_shipping_packages_on_shipment_id"
  end

  create_table "refinery_shipping_parcels", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date "parcel_date"
    t.string "from_name"
    t.integer "from_contact_id"
    t.string "courier"
    t.string "air_waybill_no"
    t.string "to_name"
    t.integer "to_user_id"
    t.integer "shipping_document_id"
    t.boolean "receiver_signed", default: false, null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "received_by_id"
    t.integer "assigned_to_id"
    t.string "description"
    t.index ["assigned_to_id"], name: "index_refinery_shipping_parcels_on_assigned_to_id"
    t.index ["from_contact_id"], name: "index_refinery_shipping_parcels_on_from_contact_id"
    t.index ["position"], name: "index_refinery_shipping_parcels_on_position"
    t.index ["received_by_id"], name: "index_refinery_shipping_parcels_on_received_by_id"
    t.index ["receiver_signed"], name: "index_refinery_shipping_parcels_on_receiver_signed"
    t.index ["shipping_document_id"], name: "index_refinery_shipping_parcels_on_shipping_document_id"
    t.index ["to_user_id"], name: "index_refinery_shipping_parcels_on_to_user_id"
  end

  create_table "refinery_shipping_routes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "shipment_id"
    t.integer "location_id"
    t.string "route_type"
    t.string "route_description"
    t.text "notes"
    t.string "status"
    t.datetime "arrived_at"
    t.datetime "departed_at"
    t.integer "prior_route_id"
    t.boolean "final_destination", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["arrived_at"], name: "index_refinery_shipping_routes_on_arrived_at"
    t.index ["departed_at"], name: "index_refinery_shipping_routes_on_departed_at"
    t.index ["final_destination"], name: "index_refinery_shipping_routes_on_final_destination"
    t.index ["location_id"], name: "index_refinery_shipping_routes_on_location_id"
    t.index ["prior_route_id"], name: "index_refinery_shipping_routes_on_prior_route_id"
    t.index ["route_description"], name: "index_refinery_shipping_routes_on_route_description"
    t.index ["route_type"], name: "index_refinery_shipping_routes_on_route_type"
    t.index ["shipment_id"], name: "index_refinery_shipping_routes_on_shipment_id"
    t.index ["status"], name: "index_refinery_shipping_routes_on_status"
  end

  create_table "refinery_shipping_shipment_accounts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "contact_id"
    t.string "description"
    t.string "courier"
    t.string "account_no"
    t.text "comments"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_no"], name: "index_refinery_shipping_shipment_accounts_on_account_no"
    t.index ["contact_id"], name: "index_refinery_shipping_shipment_accounts_on_contact_id"
    t.index ["courier"], name: "index_refinery_shipping_shipment_accounts_on_courier"
    t.index ["position"], name: "index_refinery_shipping_shipment_accounts_on_position"
  end

  create_table "refinery_shipping_shipment_parcels", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "shipment_id"
    t.integer "length"
    t.integer "width"
    t.integer "height"
    t.integer "weight"
    t.string "predefined_package"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.integer "quantity", default: 0, null: false
    t.decimal "value", precision: 8, scale: 2
    t.string "origin_country"
    t.string "contents_type"
    t.index ["position"], name: "index_refinery_shipping_shipment_parcels_on_position"
  end

  create_table "refinery_shipping_shipments", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "from_contact_id"
    t.integer "from_address_id"
    t.integer "to_contact_id"
    t.integer "to_address_id"
    t.integer "created_by_id"
    t.integer "assigned_to_id"
    t.string "courier_company_label"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bill_to_account_id"
    t.string "bill_to"
    t.string "description"
    t.string "label_url"
    t.string "tracking_number"
    t.string "tracking_status"
    t.string "status"
    t.string "easypost_object_id"
    t.text "rates_content"
    t.string "rate_object_id"
    t.string "rate_service"
    t.decimal "rate_amount", precision: 13, scale: 4
    t.string "rate_currency"
    t.date "etd_date"
    t.text "tracking_info"
    t.integer "project_id"
    t.string "code"
    t.integer "receiver_company_id"
    t.integer "shipper_company_id"
    t.integer "consignee_company_id"
    t.integer "consignee_address_id"
    t.string "consignee_reference"
    t.string "mode"
    t.string "forwarder_company_label"
    t.string "forwarder_booking_number"
    t.string "comments"
    t.integer "no_of_parcels"
    t.decimal "duty_amount", precision: 13, scale: 4
    t.decimal "terminal_fee_amount", precision: 13, scale: 4
    t.decimal "domestic_transportation_cost_amount", precision: 13, scale: 4
    t.decimal "forwarding_fee_amount", precision: 13, scale: 4
    t.decimal "freight_cost_amount", precision: 13, scale: 4
    t.decimal "volume_amount", precision: 13, scale: 4
    t.decimal "volume_manual_amount", precision: 13, scale: 4
    t.string "volume_unit"
    t.decimal "gross_weight_amount", precision: 13, scale: 4
    t.decimal "gross_weight_manual_amount", precision: 13, scale: 4
    t.decimal "net_weight_amount", precision: 13, scale: 4
    t.decimal "net_weight_manual_amount", precision: 13, scale: 4
    t.decimal "chargeable_weight_amount", precision: 13, scale: 4
    t.decimal "chargeable_weight_manual_amount", precision: 13, scale: 4
    t.string "weight_unit"
    t.string "from_contact_label"
    t.string "shipper_company_label"
    t.string "to_contact_label"
    t.string "receiver_company_label"
    t.string "consignee_company_label"
    t.string "created_by_label"
    t.string "assigned_to_label"
    t.date "eta_date"
    t.integer "supplier_company_id"
    t.string "supplier_company_label"
    t.integer "forwarder_company_id"
    t.string "load_port"
    t.integer "courier_company_id"
    t.string "shipment_terms"
    t.text "shipment_terms_details"
    t.datetime "archived_at"
    t.string "length_unit"
    t.date "cargo_ready_date"
    t.integer "no_of_parcels_manual"
    t.index ["archived_at"], name: "index_refinery_shipping_shipments_on_archived_at"
    t.index ["assigned_to_id"], name: "index_refinery_shipping_shipments_on_assigned_to_id"
    t.index ["assigned_to_label"], name: "index_refinery_shipping_shipments_on_assigned_to_label"
    t.index ["bill_to_account_id"], name: "index_refinery_parcels_shipments_on_bta_id"
    t.index ["cargo_ready_date"], name: "index_refinery_shipping_shipments_on_cargo_ready_date"
    t.index ["code"], name: "index_refinery_shipping_shipments_on_code"
    t.index ["comments"], name: "index_refinery_shipping_shipments_on_comments"
    t.index ["consignee_address_id"], name: "index_refinery_shipping_shipments_on_consignee_address_id"
    t.index ["consignee_company_id"], name: "index_refinery_shipping_shipments_on_consignee_company_id"
    t.index ["consignee_company_label"], name: "index_refinery_shipping_shipments_on_consignee_company_label"
    t.index ["consignee_reference"], name: "index_refinery_shipping_shipments_on_consignee_reference"
    t.index ["courier_company_id"], name: "index_refinery_shipping_shipments_on_courier_company_id"
    t.index ["created_by_id"], name: "index_refinery_shipping_shipments_on_created_by_id"
    t.index ["created_by_label"], name: "index_refinery_shipping_shipments_on_created_by_label"
    t.index ["easypost_object_id"], name: "index_refinery_parcels_shipments_on_eo_id"
    t.index ["eta_date"], name: "index_refinery_shipping_shipments_on_eta_date"
    t.index ["forwarder_booking_number"], name: "index_refinery_shipping_shipments_on_forwarder_booking_number"
    t.index ["forwarder_company_id"], name: "index_refinery_shipping_shipments_on_forwarder_company_id"
    t.index ["forwarder_company_label"], name: "index_refinery_shipping_shipments_on_forwarder_company_label"
    t.index ["from_address_id"], name: "index_refinery_shipping_shipments_on_from_address_id"
    t.index ["from_contact_id"], name: "index_refinery_shipping_shipments_on_from_contact_id"
    t.index ["from_contact_label"], name: "index_refinery_shipping_shipments_on_from_contact_label"
    t.index ["mode"], name: "index_refinery_shipping_shipments_on_mode"
    t.index ["no_of_parcels"], name: "index_refinery_shipping_shipments_on_no_of_parcels"
    t.index ["no_of_parcels_manual"], name: "index_refinery_shipping_shipments_on_no_of_parcels_manual"
    t.index ["position"], name: "index_refinery_shipping_shipments_on_position"
    t.index ["project_id"], name: "index_refinery_shipping_shipments_on_project_id"
    t.index ["receiver_company_id"], name: "index_refinery_shipping_shipments_on_receiver_company_id"
    t.index ["receiver_company_label"], name: "index_refinery_shipping_shipments_on_receiver_company_label"
    t.index ["shipment_terms"], name: "index_refinery_shipping_shipments_on_shipment_terms"
    t.index ["shipper_company_id"], name: "index_refinery_shipping_shipments_on_shipper_company_id"
    t.index ["shipper_company_label"], name: "index_refinery_shipping_shipments_on_shipper_company_label"
    t.index ["status"], name: "index_refinery_shipping_shipments_on_status"
    t.index ["supplier_company_id"], name: "index_refinery_shipping_shipments_on_supplier_company_id"
    t.index ["supplier_company_label"], name: "index_refinery_shipping_shipments_on_supplier_company_label"
    t.index ["to_address_id"], name: "index_refinery_shipping_shipments_on_to_address_id"
    t.index ["to_contact_id"], name: "index_refinery_shipping_shipments_on_to_contact_id"
    t.index ["to_contact_label"], name: "index_refinery_shipping_shipments_on_to_contact_label"
  end

  create_table "refinery_shows", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "website"
    t.integer "logo_id"
    t.text "description"
    t.text "msg_json_struct"
    t.datetime "last_sync_datetime"
    t.string "last_sync_result"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refinery_sick_leaves", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "employee_id"
    t.integer "event_id"
    t.integer "doctors_note_id"
    t.date "start_date"
    t.boolean "start_half_day", default: false, null: false
    t.date "end_date"
    t.boolean "end_half_day", default: false, null: false
    t.decimal "number_of_days", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctors_note_id"], name: "index_refinery_sick_leaves_on_doctors_note_id"
    t.index ["employee_id"], name: "index_refinery_sick_leaves_on_employee_id"
    t.index ["end_date"], name: "index_refinery_sick_leaves_on_end_date"
    t.index ["event_id"], name: "index_refinery_sick_leaves_on_event_id"
    t.index ["start_date"], name: "index_refinery_sick_leaves_on_start_date"
  end

  create_table "refinery_xero_accounts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "guid"
    t.string "code"
    t.string "name"
    t.string "account_type"
    t.string "account_class"
    t.string "status"
    t.string "currency_code"
    t.string "tax_type"
    t.string "description"
    t.string "system_account"
    t.boolean "enable_payments_account"
    t.boolean "show_in_expense_claims"
    t.string "bank_account_number"
    t.string "reporting_code"
    t.string "reporting_code_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "inactive", default: false, null: false
    t.boolean "featured", default: false, null: false
    t.text "when_to_use"
    t.index ["featured"], name: "index_refinery_xero_accounts_on_featured"
    t.index ["guid"], name: "index_refinery_xero_accounts_on_guid"
    t.index ["inactive"], name: "index_refinery_xero_accounts_on_inactive"
  end

  create_table "refinery_xero_api_keyfiles", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "organisation"
    t.text "key_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "consumer_key"
    t.string "consumer_secret"
    t.string "encryption_key"
    t.index ["organisation"], name: "index_refinery_xero_api_keyfiles_on_organisation"
  end

  create_table "refinery_xero_contacts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "guid"
    t.string "contact_number"
    t.string "contact_status"
    t.string "name"
    t.string "tax_number"
    t.string "bank_account_details"
    t.string "accounts_receivable_tax_type"
    t.string "accounts_payable_tax_type"
    t.string "first_name"
    t.string "last_name"
    t.string "email_address"
    t.string "skype_user_name"
    t.string "contact_groups"
    t.string "default_currency"
    t.datetime "updated_date_utc"
    t.boolean "is_supplier", default: false, null: false
    t.boolean "is_customer", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "inactive", default: false, null: false
    t.index ["guid"], name: "index_refinery_xero_contacts_on_guid"
    t.index ["inactive"], name: "index_refinery_xero_contacts_on_inactive"
  end

  create_table "refinery_xero_expense_claim_attachments", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "xero_expense_claim_id"
    t.integer "resource_id"
    t.string "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "refinery_xeca_on_guid"
    t.index ["resource_id"], name: "refinery_xeca_on_resource_id"
    t.index ["xero_expense_claim_id"], name: "refinery_xeca_on_xero_expense_claim_id"
  end

  create_table "refinery_xero_expense_claims", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "employee_id"
    t.string "description"
    t.string "guid"
    t.string "status"
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "amount_due", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "amount_paid", precision: 10, scale: 2, default: "0.0", null: false
    t.date "payment_due_date"
    t.date "reporting_date"
    t.datetime "updated_date_utc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "added_by_id"
    t.string "error_reason"
    t.index ["added_by_id"], name: "index_refinery_xero_expense_claims_on_added_by_id"
    t.index ["employee_id"], name: "index_refinery_xero_expense_claims_on_employee_id"
    t.index ["guid"], name: "index_refinery_xero_expense_claims_on_guid"
    t.index ["updated_date_utc"], name: "index_refinery_xero_expense_claims_on_updated_date_utc"
  end

  create_table "refinery_xero_line_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "xero_receipt_id"
    t.integer "xero_account_id"
    t.string "item_code"
    t.string "description"
    t.decimal "quantity", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "unit_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.string "account_code"
    t.string "tax_type"
    t.decimal "tax_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "line_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "discount_rate", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "tracking_categories_and_options"
    t.index ["xero_account_id"], name: "index_refinery_xero_line_items_on_xero_account_id"
    t.index ["xero_receipt_id"], name: "index_refinery_xero_line_items_on_xero_receipt_id"
  end

  create_table "refinery_xero_receipts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "employee_id"
    t.integer "xero_expense_claim_id"
    t.string "guid"
    t.string "receipt_number"
    t.string "reference"
    t.string "status"
    t.string "line_amount_types"
    t.decimal "sub_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_tax", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.date "date"
    t.string "url"
    t.boolean "has_attachments", default: false, null: false
    t.datetime "updated_date_utc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "xero_contact_id"
    t.index ["employee_id"], name: "index_refinery_xero_receipts_on_employee_id"
    t.index ["guid"], name: "index_refinery_xero_receipts_on_guid"
    t.index ["updated_date_utc"], name: "index_refinery_xero_receipts_on_updated_date_utc"
    t.index ["xero_contact_id"], name: "index_refinery_xero_receipts_on_xero_contact_id"
    t.index ["xero_expense_claim_id"], name: "index_refinery_xero_receipts_on_xero_expense_claim_id"
  end

  create_table "refinery_xero_tracking_categories", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "guid"
    t.string "name"
    t.string "status"
    t.text "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "index_refinery_xero_tracking_categories_on_guid"
    t.index ["name"], name: "index_refinery_xero_tracking_categories_on_name"
    t.index ["status"], name: "index_refinery_xero_tracking_categories_on_status"
  end

  create_table "rest_hooks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.string "event_name"
    t.string "hook_url"
    t.text "scope"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_name"], name: "index_rest_hooks_on_event_name"
    t.index ["hook_url"], name: "index_rest_hooks_on_hook_url"
    t.index ["user_id"], name: "index_rest_hooks_on_user_id"
  end

  create_table "seo_meta", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "seo_meta_id"
    t.string "seo_meta_type"
    t.string "browser_title"
    t.text "meta_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_seo_meta_on_id"
    t.index ["seo_meta_id", "seo_meta_type"], name: "id_type_index_on_seo_meta"
  end

  create_table "taggings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context"
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  end

  create_table "tags", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "user_settings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.string "identifier"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_user_settings_on_identifier"
    t.index ["user_id"], name: "index_user_settings_on_user_id"
  end

  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
end
