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

ActiveRecord::Schema.define(version: 20200323131342) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_notifications", id: :serial, force: :cascade do |t|
    t.integer "target_id", null: false
    t.string "target_type", limit: 255, null: false
    t.integer "notifiable_id", null: false
    t.string "notifiable_type", limit: 255, null: false
    t.string "key", limit: 255, null: false
    t.integer "group_id"
    t.string "group_type", limit: 255
    t.integer "group_owner_id"
    t.integer "notifier_id"
    t.string "notifier_type", limit: 255
    t.text "parameters"
    t.datetime "opened_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_owner_id"], name: "public_activity_notifications_group_owner_id0_idx"
    t.index ["group_type", "group_id"], name: "public_activity_notifications_group_type3_idx"
    t.index ["notifiable_type", "notifiable_id"], name: "public_activity_notifications_notifiable_type2_idx"
    t.index ["notifier_type", "notifier_id"], name: "public_activity_notifications_notifier_type4_idx"
    t.index ["target_type", "target_id"], name: "public_activity_notifications_target_type1_idx"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by", limit: 255
    t.string "queue", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "handler"
    t.index ["priority", "run_at"], name: "public_delayed_jobs_priority0_idx"
  end

  create_table "notifications_subscriptions", id: :serial, force: :cascade do |t|
    t.integer "target_id", null: false
    t.string "target_type", limit: 255, null: false
    t.string "key", limit: 255, null: false
    t.boolean "subscribing", default: true, null: false
    t.boolean "subscribing_to_email", default: true, null: false
    t.datetime "subscribed_at"
    t.datetime "unsubscribed_at"
    t.datetime "subscribed_to_email_at"
    t.datetime "unsubscribed_to_email_at"
    t.text "optional_targets"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "public_notifications_subscriptions_key1_idx"
    t.index ["target_type", "target_id", "key"], name: "public_notifications_subscriptions_target_type0_idx", unique: true
    t.index ["target_type", "target_id"], name: "public_notifications_subscriptions_target_type2_idx"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", limit: 255, null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes", limit: 255
    t.index ["application_id"], name: "public_oauth_access_grants_application_id2_idx"
    t.index ["resource_owner_id"], name: "public_oauth_access_grants_resource_owner_id1_idx"
    t.index ["token"], name: "public_oauth_access_grants_token0_idx", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id"
    t.string "token", limit: 255, null: false
    t.string "refresh_token", limit: 255
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes", limit: 255
    t.string "previous_refresh_token", limit: 255, default: ""
    t.index ["application_id"], name: "public_oauth_access_tokens_application_id3_idx"
    t.index ["refresh_token"], name: "public_oauth_access_tokens_refresh_token1_idx", unique: true
    t.index ["resource_owner_id"], name: "public_oauth_access_tokens_resource_owner_id2_idx"
    t.index ["token"], name: "public_oauth_access_tokens_token0_idx", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "uid", limit: 255, null: false
    t.string "secret", limit: 255, null: false
    t.text "redirect_uri", null: false
    t.string "scopes", limit: 255, default: ""
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "public_oauth_applications_uid0_idx", unique: true
  end

  create_table "omni_authentications", force: :cascade do |t|
    t.integer "user_id"
    t.string "provider", limit: 255
    t.string "uid", limit: 255
    t.text "token"
    t.string "refresh_token", limit: 255
    t.text "auth_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "token_expires"
    t.text "extra"
    t.index ["provider"], name: "public_omni_authentications_provider1_idx"
    t.index ["uid"], name: "public_omni_authentications_uid2_idx"
    t.index ["user_id"], name: "public_omni_authentications_user_id0_idx"
  end

  create_table "omni_authorizations", force: :cascade do |t|
    t.integer "omni_authentication_id"
    t.integer "company_id"
    t.string "type", limit: 255
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.index ["account_id"], name: "public_omni_authorizations_account_id3_idx"
    t.index ["company_id"], name: "public_omni_authorizations_company_id1_idx"
    t.index ["omni_authentication_id"], name: "public_omni_authorizations_omni_authentication_id0_idx"
    t.index ["type"], name: "public_omni_authorizations_type2_idx"
  end

  create_table "refinery_addons_comments", force: :cascade do |t|
    t.integer "commentable_id"
    t.string "commentable_type", limit: 255
    t.integer "comment_by_id"
    t.string "comment_by_type", limit: 255
    t.text "zendesk_meta"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "zendesk_id"
    t.datetime "commented_at"
    t.string "comment_by_email", limit: 255
    t.string "comment_by_full_name", limit: 255
    t.index ["comment_by_id", "comment_by_type"], name: "public_refinery_addons_comments_comment_by_id1_idx"
    t.index ["commentable_id", "commentable_type"], name: "public_refinery_addons_comments_commentable_id0_idx"
    t.index ["commented_at"], name: "public_refinery_addons_comments_commented_at2_idx"
  end

  create_table "refinery_annual_leave_records", id: :serial, force: :cascade do |t|
    t.integer "employee_id"
    t.integer "annual_leave_id"
    t.string "record_type", limit: 255
    t.date "record_date"
    t.decimal "record_value", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["annual_leave_id"], name: "public_refinery_annual_leave_records_annual_leave_id1_idx"
    t.index ["employee_id"], name: "public_refinery_annual_leave_records_employee_id0_idx"
    t.index ["record_date"], name: "public_refinery_annual_leave_records_record_date3_idx"
    t.index ["record_type"], name: "public_refinery_annual_leave_records_record_type2_idx"
  end

  create_table "refinery_annual_leaves", id: :serial, force: :cascade do |t|
    t.integer "employee_id"
    t.integer "event_id"
    t.date "start_date"
    t.boolean "start_half_day", default: false, null: false
    t.date "end_date"
    t.boolean "end_half_day", default: false, null: false
    t.decimal "number_of_days", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "public_refinery_annual_leaves_employee_id0_idx"
    t.index ["end_date"], name: "public_refinery_annual_leaves_end_date3_idx"
    t.index ["event_id"], name: "public_refinery_annual_leaves_event_id1_idx"
    t.index ["start_date"], name: "public_refinery_annual_leaves_start_date2_idx"
  end

  create_table "refinery_authentication_devise_roles", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
  end

  create_table "refinery_authentication_devise_roles_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id", "user_id"], name: "public_refinery_authentication_devise_roles_users_role_id0_idx"
    t.index ["user_id", "role_id"], name: "public_refinery_authentication_devise_roles_users_user_id1_idx"
  end

  create_table "refinery_authentication_devise_user_plugins", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name", limit: 255
    t.integer "position"
    t.index ["name"], name: "public_refinery_authentication_devise_user_plugins_name1_idx"
    t.index ["user_id", "name"], name: "public_refinery_authentication_devise_user_plugins_user_id0_idx", unique: true
  end

  create_table "refinery_authentication_devise_users", id: :serial, force: :cascade do |t|
    t.string "username", limit: 255, null: false
    t.string "email", limit: 255, null: false
    t.string "encrypted_password", limit: 255, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.integer "sign_in_count"
    t.datetime "remember_created_at"
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", limit: 255
    t.datetime "password_changed_at"
    t.string "full_name", limit: 255
    t.string "invitation_token", limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type", limit: 255
    t.integer "invitations_count", default: 0
    t.boolean "deactivated", default: false, null: false
    t.string "topo_id", limit: 255
    t.datetime "last_active_at"
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "timezone", limit: 255
    t.index ["full_name"], name: "public_refinery_authentication_devise_users_full_name4_idx"
    t.index ["id"], name: "public_refinery_authentication_devise_users_id2_idx"
    t.index ["invitation_token"], name: "public_refinery_authentication_devise_users_invitation_token0_i", unique: true
    t.index ["invitations_count"], name: "public_refinery_authentication_devise_users_invitations_count5_"
    t.index ["invited_by_id"], name: "public_refinery_authentication_devise_users_invited_by_id6_idx"
    t.index ["last_active_at"], name: "public_refinery_authentication_devise_users_last_active_at8_idx"
    t.index ["password_changed_at"], name: "public_refinery_authentication_devise_users_password_changed_at"
    t.index ["slug"], name: "public_refinery_authentication_devise_users_slug3_idx"
    t.index ["topo_id"], name: "public_refinery_authentication_devise_users_topo_id7_idx"
  end

  create_table "refinery_blog_categories", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug", limit: 255
    t.index ["id"], name: "public_refinery_blog_categories_id0_idx"
    t.index ["slug"], name: "public_refinery_blog_categories_slug1_idx"
  end

  create_table "refinery_blog_categories_blog_posts", id: :serial, force: :cascade do |t|
    t.integer "blog_category_id"
    t.integer "blog_post_id"
    t.index ["blog_category_id", "blog_post_id"], name: "public_refinery_blog_categories_blog_posts_blog_category_id0_id"
  end

  create_table "refinery_blog_category_translations", force: :cascade do |t|
    t.integer "refinery_blog_category_id", null: false
    t.string "locale", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", limit: 255
    t.string "slug", limit: 255
    t.index ["locale"], name: "public_refinery_blog_category_translations_locale1_idx"
    t.index ["refinery_blog_category_id"], name: "public_refinery_blog_category_translations_refinery_blog_catego"
  end

  create_table "refinery_blog_comments", id: :serial, force: :cascade do |t|
    t.integer "blog_post_id"
    t.boolean "spam"
    t.string "name", limit: 255
    t.string "email", limit: 255
    t.text "body"
    t.string "state", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["blog_post_id"], name: "public_refinery_blog_comments_blog_post_id1_idx"
    t.index ["id"], name: "public_refinery_blog_comments_id0_idx"
  end

  create_table "refinery_blog_post_translations", force: :cascade do |t|
    t.integer "refinery_blog_post_id", null: false
    t.string "locale", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body"
    t.text "custom_teaser"
    t.string "custom_url", limit: 255
    t.string "slug", limit: 255
    t.string "title", limit: 255
    t.index ["locale"], name: "public_refinery_blog_post_translations_locale1_idx"
    t.index ["refinery_blog_post_id"], name: "public_refinery_blog_post_translations_refinery_blog_post_id0_i"
  end

  create_table "refinery_blog_posts", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.text "body"
    t.boolean "draft"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.string "custom_url", limit: 255
    t.text "custom_teaser"
    t.string "source_url", limit: 255
    t.string "source_url_title", limit: 255
    t.integer "access_count", default: 0
    t.string "slug", limit: 255
    t.string "username", limit: 255
    t.index ["access_count"], name: "public_refinery_blog_posts_access_count1_idx"
    t.index ["id"], name: "public_refinery_blog_posts_id0_idx"
    t.index ["slug"], name: "public_refinery_blog_posts_slug2_idx"
  end

  create_table "refinery_brand_shows", id: :serial, force: :cascade do |t|
    t.integer "brand_id"
    t.integer "show_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "public_refinery_brand_shows_brand_id0_idx"
    t.index ["show_id"], name: "public_refinery_brand_shows_show_id1_idx"
  end

  create_table "refinery_brands", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "website", limit: 255
    t.integer "logo_id"
    t.text "description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refinery_business_accounts", id: :serial, force: :cascade do |t|
    t.string "organisation", limit: 255
    t.text "key_content"
    t.string "consumer_key", limit: 255
    t.string "consumer_secret", limit: 255
    t.string "encryption_key", limit: 255
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "bank_details"
    t.index ["organisation"], name: "public_refinery_business_accounts_organisation0_idx"
    t.index ["position"], name: "public_refinery_business_accounts_position1_idx"
  end

  create_table "refinery_business_articles", id: :serial, force: :cascade do |t|
    t.string "item_id", limit: 255
    t.string "code", limit: 255
    t.string "name", limit: 255
    t.text "description"
    t.boolean "is_sold", default: false, null: false
    t.boolean "is_purchased", default: false, null: false
    t.boolean "is_public", default: false, null: false
    t.integer "company_id"
    t.boolean "is_managed", default: false, null: false
    t.datetime "updated_date_utc"
    t.string "managed_status", limit: 255
    t.datetime "archived_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_voucher", default: false, null: false
    t.text "voucher_constraint"
    t.integer "account_id"
    t.decimal "purchase_unit_price", precision: 13, scale: 4, default: "0.0", null: false
    t.decimal "sales_unit_price", precision: 13, scale: 4, default: "0.0", null: false
    t.boolean "is_discount", default: false, null: false
    t.index ["account_id"], name: "public_refinery_business_articles_account_id12_idx"
    t.index ["archived_at"], name: "public_refinery_business_articles_archived_at10_idx"
    t.index ["code"], name: "public_refinery_business_articles_code1_idx"
    t.index ["company_id"], name: "public_refinery_business_articles_company_id6_idx"
    t.index ["is_discount"], name: "public_refinery_business_articles_is_discount13_idx"
    t.index ["is_managed"], name: "public_refinery_business_articles_is_managed7_idx"
    t.index ["is_public"], name: "public_refinery_business_articles_is_public5_idx"
    t.index ["is_purchased"], name: "public_refinery_business_articles_is_purchased4_idx"
    t.index ["is_sold"], name: "public_refinery_business_articles_is_sold3_idx"
    t.index ["is_voucher"], name: "public_refinery_business_articles_is_voucher11_idx"
    t.index ["item_id"], name: "public_refinery_business_articles_item_id0_idx"
    t.index ["managed_status"], name: "public_refinery_business_articles_managed_status9_idx"
    t.index ["name"], name: "public_refinery_business_articles_name2_idx"
    t.index ["updated_date_utc"], name: "public_refinery_business_articles_updated_date_utc8_idx"
  end

  create_table "refinery_business_billables", id: :serial, force: :cascade do |t|
    t.integer "company_id"
    t.integer "project_id"
    t.integer "section_id"
    t.integer "invoice_id"
    t.string "billable_type", limit: 255
    t.string "status", limit: 255
    t.string "title", limit: 255
    t.text "description"
    t.string "article_code", limit: 255
    t.decimal "qty", precision: 10
    t.string "qty_unit", limit: 255
    t.decimal "unit_price", precision: 13, scale: 4, default: "0.0", null: false
    t.decimal "discount", precision: 12, scale: 6, default: "0.0", null: false
    t.decimal "total_cost", precision: 13, scale: 4, default: "0.0", null: false
    t.string "account", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "billable_date"
    t.integer "assigned_to_id"
    t.string "assigned_to_label", limit: 255
    t.datetime "archived_at"
    t.integer "article_id"
    t.integer "line_item_sales_id"
    t.integer "line_item_discount_id"
    t.integer "billed_company_id"
    t.integer "billed_invoice_id"
    t.boolean "bill_happy_rabbit", default: false, null: false
    t.index ["account"], name: "public_refinery_business_billables_account12_idx"
    t.index ["archived_at"], name: "public_refinery_business_billables_archived_at16_idx"
    t.index ["article_code"], name: "public_refinery_business_billables_article_code7_idx"
    t.index ["article_id"], name: "public_refinery_business_billables_article_id17_idx"
    t.index ["assigned_to_id"], name: "public_refinery_business_billables_assigned_to_id14_idx"
    t.index ["assigned_to_label"], name: "public_refinery_business_billables_assigned_to_label15_idx"
    t.index ["bill_happy_rabbit"], name: "public_refinery_business_billables_bill_happy_rabbit22_idx"
    t.index ["billable_date"], name: "public_refinery_business_billables_billable_date13_idx"
    t.index ["billable_type"], name: "public_refinery_business_billables_billable_type4_idx"
    t.index ["billed_company_id"], name: "public_refinery_business_billables_billed_company_id20_idx"
    t.index ["billed_invoice_id"], name: "public_refinery_business_billables_billed_invoice_id21_idx"
    t.index ["company_id"], name: "public_refinery_business_billables_company_id0_idx"
    t.index ["invoice_id"], name: "public_refinery_business_billables_invoice_id3_idx"
    t.index ["line_item_discount_id"], name: "public_refinery_business_billables_line_item_discount_id19_idx"
    t.index ["line_item_sales_id"], name: "public_refinery_business_billables_line_item_sales_id18_idx"
    t.index ["project_id"], name: "public_refinery_business_billables_project_id1_idx"
    t.index ["qty"], name: "public_refinery_business_billables_qty8_idx"
    t.index ["qty_unit"], name: "public_refinery_business_billables_qty_unit9_idx"
    t.index ["section_id"], name: "public_refinery_business_billables_section_id2_idx"
    t.index ["status"], name: "public_refinery_business_billables_status5_idx"
    t.index ["title"], name: "public_refinery_business_billables_title6_idx"
    t.index ["total_cost"], name: "public_refinery_business_billables_total_cost11_idx"
    t.index ["unit_price"], name: "public_refinery_business_billables_unit_price10_idx"
  end

  create_table "refinery_business_budget_items", id: :serial, force: :cascade do |t|
    t.integer "budget_id"
    t.string "description", limit: 255
    t.integer "no_of_products", default: 0, null: false
    t.integer "no_of_skus", default: 0, null: false
    t.decimal "price", precision: 8, scale: 2, default: "0.0", null: false
    t.integer "quantity", default: 0, null: false
    t.decimal "margin", precision: 6, scale: 5, default: "0.0", null: false
    t.text "comments"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_id"], name: "public_refinery_business_budget_items_budget_id0_idx"
  end

  create_table "refinery_business_budgets", id: :serial, force: :cascade do |t|
    t.string "description", limit: 255, default: "", null: false
    t.string "customer_name", limit: 255, default: "", null: false
    t.integer "customer_contact_id"
    t.date "from_date"
    t.date "to_date"
    t.string "account_manager_name", limit: 255, default: ""
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
    t.index ["account_manager_user_id"], name: "public_refinery_business_budgets_account_manager_user_id2_idx"
    t.index ["customer_contact_id"], name: "public_refinery_business_budgets_customer_contact_id1_idx"
    t.index ["description"], name: "public_refinery_business_budgets_description0_idx"
  end

  create_table "refinery_business_companies", id: :serial, force: :cascade do |t|
    t.integer "contact_id"
    t.string "code", limit: 255
    t.string "name", limit: 255
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "country_code", limit: 255
    t.string "city", limit: 255
    t.datetime "verified_at"
    t.integer "verified_by_id"
    t.string "uuid", limit: 255
    t.index ["city"], name: "public_refinery_business_companies_city5_idx"
    t.index ["code"], name: "public_refinery_business_companies_code1_idx"
    t.index ["contact_id"], name: "public_refinery_business_companies_contact_id0_idx"
    t.index ["country_code"], name: "public_refinery_business_companies_country_code4_idx"
    t.index ["name"], name: "public_refinery_business_companies_name2_idx"
    t.index ["position"], name: "public_refinery_business_companies_position3_idx"
    t.index ["uuid"], name: "public_refinery_business_companies_uuid8_idx"
    t.index ["verified_at"], name: "public_refinery_business_companies_verified_at6_idx"
    t.index ["verified_by_id"], name: "public_refinery_business_companies_verified_by_id7_idx"
  end

  create_table "refinery_business_company_users", id: :serial, force: :cascade do |t|
    t.integer "company_id"
    t.integer "user_id"
    t.string "role", limit: 255
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["company_id"], name: "public_refinery_business_company_users_company_id0_idx"
    t.index ["position"], name: "public_refinery_business_company_users_position3_idx"
    t.index ["role"], name: "public_refinery_business_company_users_role2_idx"
    t.index ["user_id"], name: "public_refinery_business_company_users_user_id1_idx"
  end

  create_table "refinery_business_documents", force: :cascade do |t|
    t.integer "company_id"
    t.integer "resource_id"
    t.string "document_type", limit: 255
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "request_id", limit: 255
    t.text "meta"
    t.index ["company_id"], name: "public_refinery_business_documents_company_id0_idx"
    t.index ["document_type"], name: "public_refinery_business_documents_document_type2_idx"
    t.index ["request_id"], name: "public_refinery_business_documents_request_id3_idx"
    t.index ["resource_id"], name: "public_refinery_business_documents_resource_id1_idx"
  end

  create_table "refinery_business_invoice_items", id: :serial, force: :cascade do |t|
    t.integer "invoice_id"
    t.string "line_item_id", limit: 255
    t.string "description", limit: 255
    t.decimal "quantity", precision: 13, scale: 4
    t.decimal "unit_amount", precision: 13, scale: 4
    t.string "item_code", limit: 255
    t.string "account_code", limit: 255
    t.string "tax_type", limit: 255
    t.decimal "tax_amount", precision: 13, scale: 4
    t.decimal "line_amount", precision: 13, scale: 4
    t.integer "billable_id"
    t.string "transaction_type", limit: 255
    t.integer "line_item_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_code"], name: "public_refinery_business_invoice_items_account_code4_idx"
    t.index ["billable_id"], name: "public_refinery_business_invoice_items_billable_id6_idx"
    t.index ["description"], name: "public_refinery_business_invoice_items_description2_idx"
    t.index ["invoice_id"], name: "public_refinery_business_invoice_items_invoice_id0_idx"
    t.index ["item_code"], name: "public_refinery_business_invoice_items_item_code3_idx"
    t.index ["line_item_id"], name: "public_refinery_business_invoice_items_line_item_id1_idx"
    t.index ["line_item_order"], name: "public_refinery_business_invoice_items_line_item_order8_idx"
    t.index ["tax_type"], name: "public_refinery_business_invoice_items_tax_type5_idx"
    t.index ["transaction_type"], name: "public_refinery_business_invoice_items_transaction_type7_idx"
  end

  create_table "refinery_business_invoices", id: :serial, force: :cascade do |t|
    t.integer "account_id"
    t.string "invoice_id", limit: 255
    t.string "contact_id", limit: 255
    t.string "invoice_number", limit: 255
    t.string "invoice_type", limit: 255
    t.string "reference", limit: 255
    t.string "invoice_url", limit: 255
    t.date "invoice_date"
    t.date "due_date"
    t.string "status", limit: 255
    t.decimal "total_amount", precision: 12, scale: 2, default: "0.0"
    t.decimal "amount_due", precision: 12, scale: 2, default: "0.0"
    t.decimal "amount_paid", precision: 12, scale: 2, default: "0.0"
    t.decimal "amount_credited", precision: 8, scale: 2, default: "0.0"
    t.string "currency_code", limit: 255
    t.decimal "currency_rate", precision: 12, scale: 6, default: "1.0"
    t.datetime "updated_date_utc"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "company_id"
    t.integer "project_id"
    t.integer "from_company_id"
    t.string "from_company_label", limit: 255
    t.integer "from_contact_id"
    t.integer "to_company_id"
    t.string "to_company_label", limit: 255
    t.integer "to_contact_id"
    t.datetime "archived_at"
    t.string "managed_status", limit: 255
    t.boolean "is_managed", default: false, null: false
    t.date "invoice_for_month"
    t.text "plan_details"
    t.string "buyer_reference", limit: 255
    t.string "seller_reference", limit: 255
    t.index ["account_id"], name: "public_refinery_business_invoices_account_id0_idx"
    t.index ["archived_at"], name: "public_refinery_business_invoices_archived_at17_idx"
    t.index ["buyer_reference"], name: "public_refinery_business_invoices_buyer_reference21_idx"
    t.index ["company_id"], name: "public_refinery_business_invoices_company_id9_idx"
    t.index ["contact_id"], name: "public_refinery_business_invoices_contact_id2_idx"
    t.index ["from_company_id"], name: "public_refinery_business_invoices_from_company_id11_idx"
    t.index ["from_company_label"], name: "public_refinery_business_invoices_from_company_label12_idx"
    t.index ["from_contact_id"], name: "public_refinery_business_invoices_from_contact_id13_idx"
    t.index ["invoice_date"], name: "public_refinery_business_invoices_invoice_date4_idx"
    t.index ["invoice_for_month"], name: "public_refinery_business_invoices_invoice_for_month20_idx"
    t.index ["invoice_id"], name: "public_refinery_business_invoices_invoice_id1_idx"
    t.index ["invoice_number"], name: "public_refinery_business_invoices_invoice_number3_idx"
    t.index ["invoice_type"], name: "public_refinery_business_invoices_invoice_type5_idx"
    t.index ["is_managed"], name: "public_refinery_business_invoices_is_managed19_idx"
    t.index ["managed_status"], name: "public_refinery_business_invoices_managed_status18_idx"
    t.index ["position"], name: "public_refinery_business_invoices_position8_idx"
    t.index ["project_id"], name: "public_refinery_business_invoices_project_id10_idx"
    t.index ["seller_reference"], name: "public_refinery_business_invoices_seller_reference22_idx"
    t.index ["status"], name: "public_refinery_business_invoices_status6_idx"
    t.index ["to_company_id"], name: "public_refinery_business_invoices_to_company_id14_idx"
    t.index ["to_company_label"], name: "public_refinery_business_invoices_to_company_label15_idx"
    t.index ["to_contact_id"], name: "public_refinery_business_invoices_to_contact_id16_idx"
    t.index ["total_amount"], name: "public_refinery_business_invoices_total_amount7_idx"
  end

  create_table "refinery_business_number_series", id: :serial, force: :cascade do |t|
    t.string "identifier", limit: 255
    t.integer "last_counter"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "prefix", limit: 255, default: ""
    t.string "suffix", limit: 255, default: ""
    t.integer "number_of_digits", default: 5, null: false
    t.index ["identifier"], name: "public_refinery_business_number_series_identifier0_idx"
    t.index ["last_counter"], name: "public_refinery_business_number_series_last_counter1_idx"
    t.index ["position"], name: "public_refinery_business_number_series_position2_idx"
  end

  create_table "refinery_business_order_items", id: :serial, force: :cascade do |t|
    t.integer "order_id"
    t.string "order_item_id", limit: 255
    t.integer "line_item_number"
    t.integer "article_id"
    t.string "article_code", limit: 255
    t.string "description", limit: 255
    t.decimal "ordered_qty", precision: 13, scale: 4, default: "0.0", null: false
    t.decimal "shipped_qty", precision: 13, scale: 4
    t.string "qty_unit", limit: 255
    t.decimal "unit_price", precision: 13, scale: 4, default: "0.0", null: false
    t.decimal "discount", precision: 12, scale: 6, default: "0.0", null: false
    t.decimal "total_cost", precision: 13, scale: 4, default: "0.0", null: false
    t.string "account", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account"], name: "public_refinery_business_order_items_account10_idx"
    t.index ["article_code"], name: "public_refinery_business_order_items_article_code4_idx"
    t.index ["article_id"], name: "public_refinery_business_order_items_article_id3_idx"
    t.index ["line_item_number"], name: "public_refinery_business_order_items_line_item_number2_idx"
    t.index ["order_id"], name: "public_refinery_business_order_items_order_id0_idx"
    t.index ["order_item_id"], name: "public_refinery_business_order_items_order_item_id1_idx"
    t.index ["ordered_qty"], name: "public_refinery_business_order_items_ordered_qty5_idx"
    t.index ["qty_unit"], name: "public_refinery_business_order_items_qty_unit7_idx"
    t.index ["shipped_qty"], name: "public_refinery_business_order_items_shipped_qty6_idx"
    t.index ["total_cost"], name: "public_refinery_business_order_items_total_cost9_idx"
    t.index ["unit_price"], name: "public_refinery_business_order_items_unit_price8_idx"
  end

  create_table "refinery_business_orders", id: :serial, force: :cascade do |t|
    t.string "order_id", limit: 255
    t.integer "buyer_id"
    t.string "buyer_label", limit: 255
    t.integer "seller_id"
    t.string "seller_label", limit: 255
    t.integer "project_id"
    t.string "order_number", limit: 255
    t.string "order_type", limit: 255
    t.date "order_date"
    t.integer "version_number"
    t.date "revised_date"
    t.string "reference", limit: 255
    t.text "description"
    t.date "delivery_date"
    t.text "delivery_address"
    t.text "delivery_instructions"
    t.string "ship_mode", limit: 255
    t.string "shipment_terms", limit: 255
    t.string "attention_to", limit: 255
    t.string "status", limit: 255
    t.string "proforma_invoice_label", limit: 255
    t.string "invoice_label", limit: 255
    t.decimal "ordered_qty", precision: 13, scale: 4, default: "0.0", null: false
    t.decimal "shipped_qty", precision: 13, scale: 4
    t.string "qty_unit", limit: 255
    t.string "currency_code", limit: 255
    t.decimal "total_cost", precision: 13, scale: 4, default: "0.0", null: false
    t.string "account", limit: 255
    t.datetime "updated_date_utc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account"], name: "public_refinery_business_orders_account24_idx"
    t.index ["attention_to"], name: "public_refinery_business_orders_attention_to15_idx"
    t.index ["buyer_id"], name: "public_refinery_business_orders_buyer_id1_idx"
    t.index ["buyer_label"], name: "public_refinery_business_orders_buyer_label2_idx"
    t.index ["currency_code"], name: "public_refinery_business_orders_currency_code22_idx"
    t.index ["delivery_date"], name: "public_refinery_business_orders_delivery_date12_idx"
    t.index ["invoice_label"], name: "public_refinery_business_orders_invoice_label18_idx"
    t.index ["order_date"], name: "public_refinery_business_orders_order_date8_idx"
    t.index ["order_id"], name: "public_refinery_business_orders_order_id0_idx"
    t.index ["order_number"], name: "public_refinery_business_orders_order_number6_idx"
    t.index ["order_type"], name: "public_refinery_business_orders_order_type7_idx"
    t.index ["ordered_qty"], name: "public_refinery_business_orders_ordered_qty19_idx"
    t.index ["proforma_invoice_label"], name: "public_refinery_business_orders_proforma_invoice_label17_idx"
    t.index ["project_id"], name: "public_refinery_business_orders_project_id5_idx"
    t.index ["qty_unit"], name: "public_refinery_business_orders_qty_unit21_idx"
    t.index ["reference"], name: "public_refinery_business_orders_reference11_idx"
    t.index ["revised_date"], name: "public_refinery_business_orders_revised_date10_idx"
    t.index ["seller_id"], name: "public_refinery_business_orders_seller_id3_idx"
    t.index ["seller_label"], name: "public_refinery_business_orders_seller_label4_idx"
    t.index ["ship_mode"], name: "public_refinery_business_orders_ship_mode13_idx"
    t.index ["shipment_terms"], name: "public_refinery_business_orders_shipment_terms14_idx"
    t.index ["shipped_qty"], name: "public_refinery_business_orders_shipped_qty20_idx"
    t.index ["status"], name: "public_refinery_business_orders_status16_idx"
    t.index ["total_cost"], name: "public_refinery_business_orders_total_cost23_idx"
    t.index ["updated_date_utc"], name: "public_refinery_business_orders_updated_date_utc25_idx"
    t.index ["version_number"], name: "public_refinery_business_orders_version_number9_idx"
  end

  create_table "refinery_business_plans", force: :cascade do |t|
    t.integer "company_id"
    t.integer "contract_id"
    t.string "reference", limit: 255
    t.string "title", limit: 255
    t.text "description"
    t.date "start_date"
    t.date "end_date"
    t.string "status", limit: 255
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
    t.string "currency_code", limit: 255
    t.integer "contact_person_id"
    t.integer "account_manager_id"
    t.text "payment_terms_content"
    t.string "confirmed_from_ip", limit: 255
    t.datetime "proposal_valid_until"
    t.index ["account_id"], name: "public_refinery_business_plans_account_id10_idx"
    t.index ["account_manager_id"], name: "public_refinery_business_plans_account_manager_id13_idx"
    t.index ["company_id"], name: "public_refinery_business_plans_company_id0_idx"
    t.index ["confirmed_at"], name: "public_refinery_business_plans_confirmed_at6_idx"
    t.index ["confirmed_by_id"], name: "public_refinery_business_plans_confirmed_by_id7_idx"
    t.index ["confirmed_from_ip"], name: "public_refinery_business_plans_confirmed_from_ip14_idx"
    t.index ["contact_person_id"], name: "public_refinery_business_plans_contact_person_id12_idx"
    t.index ["currency_code"], name: "public_refinery_business_plans_currency_code11_idx"
    t.index ["end_date"], name: "public_refinery_business_plans_end_date4_idx"
    t.index ["notice_given_at"], name: "public_refinery_business_plans_notice_given_at8_idx"
    t.index ["notice_given_by_id"], name: "public_refinery_business_plans_notice_given_by_id9_idx"
    t.index ["proposal_valid_until"], name: "public_refinery_business_plans_proposal_valid_until15_idx"
    t.index ["reference"], name: "public_refinery_business_plans_reference1_idx"
    t.index ["start_date"], name: "public_refinery_business_plans_start_date3_idx"
    t.index ["status"], name: "public_refinery_business_plans_status5_idx"
    t.index ["title"], name: "public_refinery_business_plans_title2_idx"
  end

  create_table "refinery_business_projects", id: :serial, force: :cascade do |t|
    t.integer "company_id"
    t.string "code", limit: 255
    t.text "description"
    t.string "status", limit: 255
    t.date "start_date"
    t.date "end_date"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "company_reference", limit: 255
    t.index ["code"], name: "public_refinery_business_projects_code1_idx"
    t.index ["company_id"], name: "public_refinery_business_projects_company_id0_idx"
    t.index ["company_reference"], name: "public_refinery_business_projects_company_reference6_idx"
    t.index ["end_date"], name: "public_refinery_business_projects_end_date4_idx"
    t.index ["position"], name: "public_refinery_business_projects_position5_idx"
    t.index ["start_date"], name: "public_refinery_business_projects_start_date3_idx"
    t.index ["status"], name: "public_refinery_business_projects_status2_idx"
  end

  create_table "refinery_business_purchases", force: :cascade do |t|
    t.integer "user_id"
    t.integer "company_id"
    t.string "status", limit: 255
    t.string "stripe_checkout_session_id", limit: 255
    t.string "stripe_payment_intent_id", limit: 255
    t.string "stripe_event_id", limit: 255
    t.string "discount_code", limit: 255
    t.decimal "sub_total_cost", precision: 13, scale: 4, default: "0.0", null: false
    t.decimal "total_discount", precision: 13, scale: 4, default: "0.0", null: false
    t.decimal "total_cost", precision: 13, scale: 4, default: "0.0", null: false
    t.text "meta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "invoice_id"
    t.string "stripe_charge_id", limit: 255
    t.string "stripe_payout_id", limit: 255
    t.index ["company_id"], name: "public_refinery_business_purchases_company_id1_idx"
    t.index ["discount_code"], name: "public_refinery_business_purchases_discount_code6_idx"
    t.index ["invoice_id"], name: "public_refinery_business_purchases_invoice_id7_idx"
    t.index ["status"], name: "public_refinery_business_purchases_status2_idx"
    t.index ["stripe_charge_id"], name: "public_refinery_business_purchases_stripe_charge_id8_idx"
    t.index ["stripe_checkout_session_id"], name: "public_refinery_business_purchases_stripe_checkout_session_id3_"
    t.index ["stripe_event_id"], name: "public_refinery_business_purchases_stripe_event_id5_idx"
    t.index ["stripe_payment_intent_id"], name: "public_refinery_business_purchases_stripe_payment_intent_id4_id"
    t.index ["stripe_payout_id"], name: "public_refinery_business_purchases_stripe_payout_id9_idx"
    t.index ["user_id"], name: "public_refinery_business_purchases_user_id0_idx"
  end

  create_table "refinery_business_requests", force: :cascade do |t|
    t.string "code", limit: 255
    t.integer "company_id"
    t.integer "created_by_id"
    t.integer "requested_by_id"
    t.string "participants", limit: 255
    t.string "request_type", limit: 255
    t.string "status", limit: 255
    t.string "subject", limit: 255
    t.date "request_date"
    t.text "description"
    t.text "comments"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "zendesk_meta"
    t.bigint "zendesk_id"
    t.text "requested_services"
    t.index ["archived_at"], name: "public_refinery_business_requests_archived_at9_idx"
    t.index ["code"], name: "public_refinery_business_requests_code0_idx"
    t.index ["company_id"], name: "public_refinery_business_requests_company_id1_idx"
    t.index ["created_by_id"], name: "public_refinery_business_requests_created_by_id2_idx"
    t.index ["participants"], name: "public_refinery_business_requests_participants4_idx"
    t.index ["request_date"], name: "public_refinery_business_requests_request_date8_idx"
    t.index ["request_type"], name: "public_refinery_business_requests_request_type5_idx"
    t.index ["requested_by_id"], name: "public_refinery_business_requests_requested_by_id3_idx"
    t.index ["status"], name: "public_refinery_business_requests_status6_idx"
    t.index ["subject"], name: "public_refinery_business_requests_subject7_idx"
  end

  create_table "refinery_business_sections", id: :serial, force: :cascade do |t|
    t.integer "project_id"
    t.string "section_type", limit: 255
    t.text "description"
    t.date "start_date"
    t.date "end_date"
    t.string "budgeted_resources", limit: 255
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["end_date"], name: "public_refinery_business_sections_end_date3_idx"
    t.index ["position"], name: "public_refinery_business_sections_position4_idx"
    t.index ["project_id"], name: "public_refinery_business_sections_project_id0_idx"
    t.index ["section_type"], name: "public_refinery_business_sections_section_type1_idx"
    t.index ["start_date"], name: "public_refinery_business_sections_start_date2_idx"
  end

  create_table "refinery_business_vouchers", id: :serial, force: :cascade do |t|
    t.integer "company_id"
    t.integer "article_id"
    t.integer "line_item_sales_purchase_id"
    t.integer "line_item_sales_discount_id"
    t.integer "line_item_sales_move_from_id"
    t.integer "line_item_prepay_move_to_id"
    t.integer "line_item_prepay_move_from_id"
    t.integer "line_item_sales_move_to_id"
    t.string "discount_type", limit: 255
    t.decimal "base_amount", precision: 13, scale: 4
    t.decimal "discount_amount", precision: 13, scale: 4
    t.decimal "discount_percentage", precision: 9, scale: 6
    t.decimal "amount", precision: 13, scale: 4
    t.string "currency_code", limit: 255
    t.datetime "valid_from"
    t.datetime "valid_to"
    t.string "status", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "code", limit: 255
    t.string "source", limit: 255
    t.integer "line_item_prepay_in_id"
    t.integer "line_item_prepay_discount_in_id"
    t.integer "line_item_prepay_out_id"
    t.integer "line_item_prepay_discount_out_id"
    t.index ["article_id"], name: "public_refinery_business_vouchers_article_id1_idx"
    t.index ["code"], name: "public_refinery_business_vouchers_code13_idx"
    t.index ["company_id"], name: "public_refinery_business_vouchers_company_id0_idx"
    t.index ["currency_code"], name: "public_refinery_business_vouchers_currency_code9_idx"
    t.index ["discount_type"], name: "public_refinery_business_vouchers_discount_type8_idx"
    t.index ["line_item_prepay_discount_in_id"], name: "public_refinery_business_vouchers_line_item_prepay_discount_in_"
    t.index ["line_item_prepay_discount_out_id"], name: "public_refinery_business_vouchers_line_item_prepay_discount_out"
    t.index ["line_item_prepay_in_id"], name: "public_refinery_business_vouchers_line_item_prepay_in_id15_idx"
    t.index ["line_item_prepay_move_from_id"], name: "public_refinery_business_vouchers_line_item_prepay_move_from_id"
    t.index ["line_item_prepay_move_to_id"], name: "public_refinery_business_vouchers_line_item_prepay_move_to_id5_"
    t.index ["line_item_prepay_out_id"], name: "public_refinery_business_vouchers_line_item_prepay_out_id17_idx"
    t.index ["line_item_sales_discount_id"], name: "public_refinery_business_vouchers_line_item_sales_discount_id3_"
    t.index ["line_item_sales_move_from_id"], name: "public_refinery_business_vouchers_line_item_sales_move_from_id4"
    t.index ["line_item_sales_move_to_id"], name: "public_refinery_business_vouchers_line_item_sales_move_to_id7_i"
    t.index ["line_item_sales_purchase_id"], name: "public_refinery_business_vouchers_line_item_sales_purchase_id2_"
    t.index ["source"], name: "public_refinery_business_vouchers_source14_idx"
    t.index ["status"], name: "public_refinery_business_vouchers_status12_idx"
    t.index ["valid_from"], name: "public_refinery_business_vouchers_valid_from10_idx"
    t.index ["valid_to"], name: "public_refinery_business_vouchers_valid_to11_idx"
  end

  create_table "refinery_calendar_calendars", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.string "function", limit: 255
    t.integer "user_id"
    t.boolean "private", default: false, null: false
    t.string "default_rgb_code", limit: 255
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["function"], name: "public_refinery_calendar_calendars_function0_idx"
    t.index ["position"], name: "public_refinery_calendar_calendars_position3_idx"
    t.index ["private"], name: "public_refinery_calendar_calendars_private2_idx"
    t.index ["user_id"], name: "public_refinery_calendar_calendars_user_id1_idx"
  end

  create_table "refinery_calendar_events", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.string "registration_link", limit: 255
    t.string "excerpt", limit: 255
    t.text "description"
    t.integer "position"
    t.boolean "featured"
    t.string "slug", limit: 255
    t.integer "venue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer "calendar_id"
    t.index ["calendar_id"], name: "public_refinery_calendar_events_calendar_id0_idx"
  end

  create_table "refinery_calendar_google_calendars", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "primary_calendar_id"
    t.string "google_calendar_id", limit: 255
    t.string "refresh_token", limit: 255
    t.integer "sync_to_id", default: 0, null: false
    t.integer "sync_from_id", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["google_calendar_id"], name: "public_refinery_calendar_google_calendars_google_calendar_id2_i"
    t.index ["primary_calendar_id"], name: "public_refinery_calendar_google_calendars_primary_calendar_id1_"
    t.index ["user_id"], name: "public_refinery_calendar_google_calendars_user_id0_idx"
  end

  create_table "refinery_calendar_google_events", id: :serial, force: :cascade do |t|
    t.integer "google_calendar_id"
    t.integer "event_id"
    t.string "google_event_id", limit: 255
    t.datetime "last_synced_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "public_refinery_calendar_google_events_event_id1_idx"
    t.index ["google_calendar_id"], name: "public_refinery_calendar_google_events_google_calendar_id0_idx"
    t.index ["google_event_id"], name: "public_refinery_calendar_google_events_google_event_id2_idx"
  end

  create_table "refinery_calendar_user_calendars", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "calendar_id"
    t.boolean "inactive", default: false, null: false
    t.string "rgb_code", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "public_refinery_calendar_user_calendars_calendar_id0_idx"
    t.index ["inactive"], name: "public_refinery_calendar_user_calendars_inactive2_idx"
    t.index ["user_id"], name: "public_refinery_calendar_user_calendars_user_id1_idx"
  end

  create_table "refinery_calendar_venues", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "address", limit: 255
    t.string "url", limit: 255
    t.string "phone", limit: 255
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refinery_contacts", id: :serial, force: :cascade do |t|
    t.integer "base_id"
    t.string "name", limit: 255
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "address", limit: 255
    t.string "city", limit: 255
    t.string "skype", limit: 255
    t.string "zip", limit: 255
    t.string "country", limit: 255
    t.string "title", limit: 255
    t.boolean "private"
    t.integer "contact_id"
    t.boolean "is_organisation"
    t.string "mobile", limit: 255
    t.string "fax", limit: 255
    t.string "website", limit: 255
    t.string "phone", limit: 255
    t.text "description"
    t.string "linked_in", limit: 255
    t.string "facebook", limit: 255
    t.string "industry", limit: 255
    t.string "twitter", limit: 255
    t.string "email", limit: 255
    t.string "organisation_name", limit: 255
    t.integer "organisation_id"
    t.string "tags_joined_by_comma", limit: 255
    t.boolean "is_sales_account"
    t.string "customer_status", limit: 255
    t.string "prospect_status", limit: 255
    t.datetime "base_modified_at"
    t.text "custom_fields"
    t.integer "position"
    t.boolean "removed_from_base", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "state", limit: 255
    t.integer "insightly_id"
    t.string "courier_company", limit: 255
    t.string "courier_account_no", limit: 255
    t.string "image_url", limit: 255
    t.string "code", limit: 255
    t.string "xero_hr_id", limit: 255
    t.string "xero_hrt_id", limit: 255
    t.string "mailchimp_id", limit: 255
    t.string "other_address", limit: 255
    t.string "other_city", limit: 255
    t.string "other_zip", limit: 255
    t.string "other_state", limit: 255
    t.string "other_country", limit: 255
    t.integer "image_id"
    t.integer "owner_id"
    t.index ["base_id"], name: "public_refinery_contacts_base_id0_idx"
    t.index ["base_modified_at"], name: "public_refinery_contacts_base_modified_at1_idx"
    t.index ["code"], name: "public_refinery_contacts_code8_idx"
    t.index ["courier_company"], name: "public_refinery_contacts_courier_company7_idx"
    t.index ["image_id"], name: "public_refinery_contacts_image_id12_idx"
    t.index ["insightly_id"], name: "public_refinery_contacts_insightly_id6_idx"
    t.index ["mailchimp_id"], name: "public_refinery_contacts_mailchimp_id11_idx"
    t.index ["organisation_id"], name: "public_refinery_contacts_organisation_id2_idx"
    t.index ["owner_id"], name: "public_refinery_contacts_owner_id13_idx"
    t.index ["removed_from_base"], name: "public_refinery_contacts_removed_from_base3_idx"
    t.index ["state"], name: "public_refinery_contacts_state5_idx"
    t.index ["user_id"], name: "public_refinery_contacts_user_id4_idx"
    t.index ["xero_hr_id"], name: "public_refinery_contacts_xero_hr_id9_idx"
    t.index ["xero_hrt_id"], name: "public_refinery_contacts_xero_hrt_id10_idx"
  end

  create_table "refinery_custom_lists_custom_lists", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refinery_custom_lists_list_cells", id: :serial, force: :cascade do |t|
    t.integer "list_row_id"
    t.integer "list_column_id"
    t.string "value", limit: 255
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_column_id"], name: "public_refinery_custom_lists_list_cells_list_column_id1_idx"
    t.index ["list_row_id"], name: "public_refinery_custom_lists_list_cells_list_row_id0_idx"
    t.index ["value"], name: "public_refinery_custom_lists_list_cells_value2_idx"
  end

  create_table "refinery_custom_lists_list_columns", id: :serial, force: :cascade do |t|
    t.integer "custom_list_id"
    t.string "title", limit: 255
    t.string "column_type", limit: 255
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_list_id"], name: "public_refinery_custom_lists_list_columns_custom_list_id0_idx"
    t.index ["position"], name: "public_refinery_custom_lists_list_columns_position1_idx"
  end

  create_table "refinery_custom_lists_list_rows", id: :serial, force: :cascade do |t|
    t.integer "custom_list_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_list_id"], name: "public_refinery_custom_lists_list_rows_custom_list_id0_idx"
    t.index ["position"], name: "public_refinery_custom_lists_list_rows_position1_idx"
  end

  create_table "refinery_employees", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "profile_image_id"
    t.string "employee_no", limit: 255
    t.string "full_name", limit: 255
    t.string "id_no", limit: 255
    t.string "title", limit: 255
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "xero_guid", limit: 255
    t.text "default_tracking_options"
    t.integer "reporting_manager_id"
    t.integer "contact_id"
    t.string "emergency_contact", limit: 255
    t.date "birthday"
    t.index ["birthday"], name: "public_refinery_employees_birthday6_idx"
    t.index ["contact_id"], name: "public_refinery_employees_contact_id5_idx"
    t.index ["employee_no"], name: "public_refinery_employees_employee_no2_idx"
    t.index ["position"], name: "public_refinery_employees_position3_idx"
    t.index ["profile_image_id"], name: "public_refinery_employees_profile_image_id1_idx"
    t.index ["reporting_manager_id"], name: "public_refinery_employees_reporting_manager_id4_idx"
    t.index ["user_id"], name: "public_refinery_employees_user_id0_idx"
  end

  create_table "refinery_employment_contracts", id: :serial, force: :cascade do |t|
    t.integer "employee_id", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.decimal "vacation_days_per_year", precision: 10, default: "0", null: false
    t.decimal "days_carried_over", precision: 10, scale: 2, default: "0.0", null: false
    t.string "country", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "public_refinery_employment_contracts_employee_id0_idx"
    t.index ["end_date"], name: "public_refinery_employment_contracts_end_date2_idx"
    t.index ["start_date"], name: "public_refinery_employment_contracts_start_date1_idx"
  end

  create_table "refinery_image_page_translations", id: :serial, force: :cascade do |t|
    t.integer "refinery_image_page_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "caption"
    t.index ["locale"], name: "public_refinery_image_page_translations_locale1_idx"
    t.index ["refinery_image_page_id"], name: "public_refinery_image_page_translations_refinery_image_page_id0"
  end

  create_table "refinery_image_pages", id: :serial, force: :cascade do |t|
    t.integer "image_id"
    t.integer "page_id"
    t.integer "position"
    t.text "caption"
    t.string "page_type", limit: 255, default: "page"
    t.index ["image_id"], name: "public_refinery_image_pages_image_id0_idx"
    t.index ["page_id"], name: "public_refinery_image_pages_page_id1_idx"
  end

  create_table "refinery_image_translations", id: :serial, force: :cascade do |t|
    t.integer "refinery_image_id", null: false
    t.string "locale", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_alt", limit: 255
    t.string "image_title", limit: 255
    t.index ["locale"], name: "public_refinery_image_translations_locale1_idx"
    t.index ["refinery_image_id"], name: "public_refinery_image_translations_refinery_image_id0_idx"
  end

  create_table "refinery_images", id: :serial, force: :cascade do |t|
    t.string "image_mime_type", limit: 255
    t.string "image_name", limit: 255
    t.integer "image_size"
    t.integer "image_width"
    t.integer "image_height"
    t.string "image_uid", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_title", limit: 255
    t.string "image_alt", limit: 255
    t.string "authorizations_access", limit: 255
    t.index ["authorizations_access"], name: "public_refinery_images_authorizations_access0_idx"
  end

  create_table "refinery_leave_of_absences", id: :serial, force: :cascade do |t|
    t.integer "employee_id"
    t.integer "event_id"
    t.integer "doctors_note_id"
    t.integer "absence_type_id"
    t.string "absence_type_description", limit: 255
    t.integer "status"
    t.date "start_date"
    t.boolean "start_half_day", default: false, null: false
    t.date "end_date"
    t.boolean "end_half_day", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["absence_type_id"], name: "public_refinery_leave_of_absences_absence_type_id3_idx"
    t.index ["doctors_note_id"], name: "public_refinery_leave_of_absences_doctors_note_id2_idx"
    t.index ["employee_id"], name: "public_refinery_leave_of_absences_employee_id0_idx"
    t.index ["end_date"], name: "public_refinery_leave_of_absences_end_date6_idx"
    t.index ["event_id"], name: "public_refinery_leave_of_absences_event_id1_idx"
    t.index ["start_date"], name: "public_refinery_leave_of_absences_start_date5_idx"
    t.index ["status"], name: "public_refinery_leave_of_absences_status4_idx"
  end

  create_table "refinery_marketing_addresses", force: :cascade do |t|
    t.integer "owner_id"
    t.string "address1", limit: 255
    t.string "address2", limit: 255
    t.string "city", limit: 255
    t.string "country", limit: 255
    t.string "postal_code", limit: 255
    t.string "province", limit: 255
    t.string "locale", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address1"], name: "public_refinery_marketing_addresses_address11_idx"
    t.index ["address2"], name: "public_refinery_marketing_addresses_address22_idx"
    t.index ["city"], name: "public_refinery_marketing_addresses_city3_idx"
    t.index ["country"], name: "public_refinery_marketing_addresses_country4_idx"
    t.index ["locale"], name: "public_refinery_marketing_addresses_locale7_idx"
    t.index ["owner_id"], name: "public_refinery_marketing_addresses_owner_id0_idx"
    t.index ["postal_code"], name: "public_refinery_marketing_addresses_postal_code5_idx"
    t.index ["province"], name: "public_refinery_marketing_addresses_province6_idx"
  end

  create_table "refinery_marketing_campaigns", force: :cascade do |t|
    t.string "title", limit: 255
    t.text "meta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "public_refinery_marketing_campaigns_title0_idx"
  end

  create_table "refinery_marketing_landing_pages", force: :cascade do |t|
    t.integer "campaign_id"
    t.integer "page_id"
    t.string "title", limit: 255
    t.string "slug", limit: 255
    t.text "meta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "public_refinery_marketing_landing_pages_campaign_id0_idx"
    t.index ["page_id"], name: "public_refinery_marketing_landing_pages_page_id1_idx"
    t.index ["slug"], name: "public_refinery_marketing_landing_pages_slug3_idx"
    t.index ["title"], name: "public_refinery_marketing_landing_pages_title2_idx"
  end

  create_table "refinery_marketing_links", force: :cascade do |t|
    t.integer "contact_id"
    t.integer "linked_id"
    t.string "linked_type", limit: 255
    t.string "relation", limit: 255
    t.string "title", limit: 255
    t.datetime "from"
    t.datetime "to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "public_refinery_marketing_links_contact_id0_idx"
    t.index ["from"], name: "public_refinery_marketing_links_from5_idx"
    t.index ["linked_id", "linked_type"], name: "public_refinery_marketing_links_linked_id1_idx"
    t.index ["linked_type"], name: "public_refinery_marketing_links_linked_type2_idx"
    t.index ["relation"], name: "public_refinery_marketing_links_relation3_idx"
    t.index ["title"], name: "public_refinery_marketing_links_title4_idx"
    t.index ["to"], name: "public_refinery_marketing_links_to6_idx"
  end

  create_table "refinery_news_item_translations", id: :serial, force: :cascade do |t|
    t.integer "refinery_news_item_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", limit: 255
    t.text "body"
    t.string "source", limit: 255
    t.string "slug", limit: 255
    t.index ["locale"], name: "public_refinery_news_item_translations_locale0_idx"
    t.index ["refinery_news_item_id"], name: "public_refinery_news_item_translations_refinery_news_item_id1_i"
  end

  create_table "refinery_news_items", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.text "body"
    t.datetime "publish_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "image_id"
    t.datetime "expiration_date"
    t.string "source", limit: 255
    t.string "slug", limit: 255
    t.index ["id"], name: "public_refinery_news_items_id0_idx"
  end

  create_table "refinery_page_part_translations", id: :serial, force: :cascade do |t|
    t.integer "refinery_page_part_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body"
    t.index ["locale"], name: "public_refinery_page_part_translations_locale1_idx"
    t.index ["refinery_page_part_id"], name: "public_refinery_page_part_translations_refinery_page_part_id0_i"
  end

  create_table "refinery_page_parts", id: :serial, force: :cascade do |t|
    t.integer "refinery_page_id"
    t.string "slug", limit: 255
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", limit: 255
    t.index ["id"], name: "public_refinery_page_parts_id0_idx"
    t.index ["refinery_page_id"], name: "public_refinery_page_parts_refinery_page_id1_idx"
  end

  create_table "refinery_page_roles", id: :serial, force: :cascade do |t|
    t.integer "page_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id", "role_id"], name: "public_refinery_page_roles_page_id0_idx"
  end

  create_table "refinery_page_translations", id: :serial, force: :cascade do |t|
    t.integer "refinery_page_id"
    t.string "locale", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", limit: 255
    t.string "custom_slug", limit: 255
    t.string "menu_title", limit: 255
    t.string "slug", limit: 255
    t.index ["locale"], name: "public_refinery_page_translations_locale1_idx"
    t.index ["refinery_page_id"], name: "public_refinery_page_translations_refinery_page_id0_idx"
  end

  create_table "refinery_pages", id: :serial, force: :cascade do |t|
    t.integer "parent_id"
    t.string "path", limit: 255
    t.boolean "show_in_menu", default: true
    t.string "link_url", limit: 255
    t.string "menu_match", limit: 255
    t.boolean "deletable", default: true
    t.boolean "draft", default: false
    t.boolean "skip_to_first_child", default: false
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth"
    t.string "view_template", limit: 255
    t.string "layout_template", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "children_count", default: 0, null: false
    t.index ["depth"], name: "public_refinery_pages_depth0_idx"
    t.index ["id"], name: "public_refinery_pages_id1_idx"
    t.index ["lft"], name: "public_refinery_pages_lft2_idx"
    t.index ["parent_id"], name: "public_refinery_pages_parent_id3_idx"
    t.index ["rgt"], name: "public_refinery_pages_rgt4_idx"
  end

  create_table "refinery_public_holidays", id: :serial, force: :cascade do |t|
    t.integer "event_id"
    t.string "title", limit: 255
    t.string "country", limit: 255
    t.date "holiday_date", null: false
    t.boolean "half_day", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "public_refinery_public_holidays_event_id0_idx"
    t.index ["holiday_date"], name: "public_refinery_public_holidays_holiday_date1_idx"
  end

  create_table "refinery_quality_assurance_defects", id: :serial, force: :cascade do |t|
    t.integer "category_code"
    t.string "category_name", limit: 255
    t.integer "defect_code"
    t.string "defect_name", limit: 255
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["category_code"], name: "public_refinery_quality_assurance_defects_category_code0_idx"
    t.index ["category_name"], name: "public_refinery_quality_assurance_defects_category_name1_idx"
    t.index ["defect_code"], name: "public_refinery_quality_assurance_defects_defect_code2_idx"
    t.index ["defect_name"], name: "public_refinery_quality_assurance_defects_defect_name3_idx"
  end

  create_table "refinery_quality_assurance_inspection_defects", id: :serial, force: :cascade do |t|
    t.integer "inspection_id"
    t.integer "defect_id"
    t.integer "critical", default: 0, null: false
    t.integer "major", default: 0, null: false
    t.integer "minor", default: 0, null: false
    t.string "comments", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "defect_label", limit: 255
    t.boolean "can_fix"
    t.index ["defect_id"], name: "public_refinery_quality_assurance_inspection_defects_defect_id1"
    t.index ["inspection_id"], name: "public_refinery_quality_assurance_inspection_defects_inspection"
  end

  create_table "refinery_quality_assurance_inspection_photos", id: :serial, force: :cascade do |t|
    t.integer "inspection_id"
    t.integer "inspection_defect_id"
    t.integer "image_id"
    t.string "file_id", limit: 255
    t.text "fields"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["file_id"], name: "public_refinery_quality_assurance_inspection_photos_file_id3_id"
    t.index ["image_id"], name: "public_refinery_quality_assurance_inspection_photos_image_id2_i"
    t.index ["inspection_id"], name: "public_refinery_quality_assurance_inspection_photos_inspection_"
  end

  create_table "refinery_quality_assurance_inspections", id: :serial, force: :cascade do |t|
    t.integer "company_id"
    t.integer "supplier_id"
    t.string "supplier_label", limit: 255
    t.integer "business_section_id"
    t.integer "business_product_id"
    t.integer "assigned_to_id"
    t.integer "resource_id"
    t.integer "inspected_by_id"
    t.string "inspected_by_name", limit: 255
    t.string "document_id", limit: 255
    t.string "result", limit: 255
    t.date "inspection_date"
    t.integer "inspection_sample_size"
    t.string "inspection_type", limit: 255
    t.string "po_number", limit: 255
    t.string "po_type", limit: 255
    t.integer "po_qty"
    t.integer "available_qty"
    t.string "product_code", limit: 255
    t.string "product_description", limit: 255
    t.string "product_colour_variants", limit: 255
    t.string "inspection_standard", limit: 255
    t.integer "acc_critical"
    t.integer "acc_major"
    t.integer "acc_minor"
    t.integer "total_critical", default: 0, null: false
    t.integer "total_major", default: 0, null: false
    t.integer "total_minor", default: 0, null: false
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "company_label", limit: 255
    t.integer "inspection_photo_id"
    t.string "company_code", limit: 255
    t.string "supplier_code", limit: 255
    t.integer "manufacturer_id"
    t.string "manufacturer_label", limit: 255
    t.string "manufacturer_code", limit: 255
    t.string "status", limit: 255
    t.string "company_project_reference", limit: 255
    t.string "project_code", limit: 255
    t.string "code", limit: 255
    t.integer "job_id"
    t.string "product_category", limit: 255
    t.string "season", limit: 255
    t.string "brand_label", limit: 255
    t.boolean "pps_available"
    t.boolean "pps_approved"
    t.text "pps_comments"
    t.boolean "tp_available"
    t.boolean "tp_approved"
    t.text "tp_comments"
    t.text "fields"
    t.index ["assigned_to_id"], name: "public_refinery_quality_assurance_inspections_assigned_to_id4_i"
    t.index ["brand_label"], name: "public_refinery_quality_assurance_inspections_brand_label29_idx"
    t.index ["business_product_id"], name: "public_refinery_quality_assurance_inspections_business_product_"
    t.index ["business_section_id"], name: "public_refinery_quality_assurance_inspections_business_section_"
    t.index ["code"], name: "public_refinery_quality_assurance_inspections_code25_idx"
    t.index ["company_code"], name: "public_refinery_quality_assurance_inspections_company_code17_id"
    t.index ["company_id"], name: "public_refinery_quality_assurance_inspections_company_id0_idx"
    t.index ["company_project_reference"], name: "public_refinery_quality_assurance_inspections_company_project_r"
    t.index ["document_id"], name: "public_refinery_quality_assurance_inspections_document_id6_idx"
    t.index ["inspection_date"], name: "public_refinery_quality_assurance_inspections_inspection_date8_"
    t.index ["inspection_photo_id"], name: "public_refinery_quality_assurance_inspections_inspection_photo_"
    t.index ["inspection_type"], name: "public_refinery_quality_assurance_inspections_inspection_type9_"
    t.index ["job_id"], name: "public_refinery_quality_assurance_inspections_job_id26_idx"
    t.index ["manufacturer_code"], name: "public_refinery_quality_assurance_inspections_manufacturer_code"
    t.index ["manufacturer_id"], name: "public_refinery_quality_assurance_inspections_manufacturer_id19"
    t.index ["manufacturer_label"], name: "public_refinery_quality_assurance_inspections_manufacturer_labe"
    t.index ["po_number"], name: "public_refinery_quality_assurance_inspections_po_number10_idx"
    t.index ["po_qty"], name: "public_refinery_quality_assurance_inspections_po_qty12_idx"
    t.index ["po_type"], name: "public_refinery_quality_assurance_inspections_po_type11_idx"
    t.index ["position"], name: "public_refinery_quality_assurance_inspections_position15_idx"
    t.index ["pps_approved"], name: "public_refinery_quality_assurance_inspections_pps_approved31_id"
    t.index ["pps_available"], name: "public_refinery_quality_assurance_inspections_pps_available30_i"
    t.index ["product_category"], name: "public_refinery_quality_assurance_inspections_product_category2"
    t.index ["product_code"], name: "public_refinery_quality_assurance_inspections_product_code13_id"
    t.index ["product_description"], name: "public_refinery_quality_assurance_inspections_product_descripti"
    t.index ["project_code"], name: "public_refinery_quality_assurance_inspections_project_code24_id"
    t.index ["resource_id"], name: "public_refinery_quality_assurance_inspections_resource_id5_idx"
    t.index ["result"], name: "public_refinery_quality_assurance_inspections_result7_idx"
    t.index ["season"], name: "public_refinery_quality_assurance_inspections_season28_idx"
    t.index ["status"], name: "public_refinery_quality_assurance_inspections_status22_idx"
    t.index ["supplier_code"], name: "public_refinery_quality_assurance_inspections_supplier_code18_i"
    t.index ["supplier_id"], name: "public_refinery_quality_assurance_inspections_supplier_id1_idx"
    t.index ["tp_approved"], name: "public_refinery_quality_assurance_inspections_tp_approved33_idx"
    t.index ["tp_available"], name: "public_refinery_quality_assurance_inspections_tp_available32_id"
  end

  create_table "refinery_quality_assurance_jobs", id: :serial, force: :cascade do |t|
    t.integer "company_id"
    t.string "company_code", limit: 255
    t.string "company_label", limit: 255
    t.integer "project_id"
    t.string "project_code", limit: 255
    t.string "company_project_reference", limit: 255
    t.integer "section_id"
    t.string "billable_type", limit: 255
    t.integer "billable_id"
    t.string "status", limit: 255
    t.string "code", limit: 255
    t.string "title", limit: 255
    t.text "description"
    t.integer "assigned_to_id"
    t.string "assigned_to_label", limit: 255
    t.string "job_type", limit: 255
    t.date "inspection_date"
    t.decimal "time_spent", precision: 8, scale: 2, default: "0.0", null: false
    t.text "time_log"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "content"
    t.bigint "zendesk_id"
    t.jsonb "zendesk_meta"
    t.index ["assigned_to_id"], name: "public_refinery_quality_assurance_jobs_assigned_to_id12_idx"
    t.index ["assigned_to_label"], name: "public_refinery_quality_assurance_jobs_assigned_to_label13_idx"
    t.index ["billable_id"], name: "public_refinery_quality_assurance_jobs_billable_id8_idx"
    t.index ["billable_type"], name: "public_refinery_quality_assurance_jobs_billable_type7_idx"
    t.index ["code"], name: "public_refinery_quality_assurance_jobs_code10_idx"
    t.index ["company_code"], name: "public_refinery_quality_assurance_jobs_company_code1_idx"
    t.index ["company_id"], name: "public_refinery_quality_assurance_jobs_company_id0_idx"
    t.index ["company_label"], name: "public_refinery_quality_assurance_jobs_company_label2_idx"
    t.index ["company_project_reference"], name: "public_refinery_quality_assurance_jobs_company_project_referenc"
    t.index ["inspection_date"], name: "public_refinery_quality_assurance_jobs_inspection_date15_idx"
    t.index ["job_type"], name: "public_refinery_quality_assurance_jobs_job_type14_idx"
    t.index ["position"], name: "public_refinery_quality_assurance_jobs_position16_idx"
    t.index ["project_code"], name: "public_refinery_quality_assurance_jobs_project_code4_idx"
    t.index ["project_id"], name: "public_refinery_quality_assurance_jobs_project_id3_idx"
    t.index ["section_id"], name: "public_refinery_quality_assurance_jobs_section_id6_idx"
    t.index ["status"], name: "public_refinery_quality_assurance_jobs_status9_idx"
    t.index ["title"], name: "public_refinery_quality_assurance_jobs_title11_idx"
    t.index ["zendesk_id"], name: "index_refinery_quality_assurance_jobs_on_zendesk_id"
  end

  create_table "refinery_resource_translations", id: :serial, force: :cascade do |t|
    t.integer "refinery_resource_id", null: false
    t.string "locale", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "resource_title", limit: 255
    t.index ["locale"], name: "public_refinery_resource_translations_locale1_idx"
    t.index ["refinery_resource_id"], name: "public_refinery_resource_translations_refinery_resource_id0_idx"
  end

  create_table "refinery_resources", id: :serial, force: :cascade do |t|
    t.string "file_mime_type", limit: 255
    t.string "file_name", limit: 255
    t.integer "file_size"
    t.string "file_uid", limit: 255
    t.string "file_ext", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authorizations_access", limit: 255
    t.index ["authorizations_access"], name: "public_refinery_resources_authorizations_access0_idx"
  end

  create_table "refinery_settings", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "value"
    t.boolean "destroyable", default: true
    t.string "scoping", limit: 255
    t.boolean "restricted", default: false
    t.string "form_value_type", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", limit: 255
    t.string "title", limit: 255
    t.index ["name"], name: "public_refinery_settings_name0_idx"
  end

  create_table "refinery_shipping_addresses", id: :serial, force: :cascade do |t|
    t.string "easy_post_id", limit: 255
    t.string "name", limit: 255
    t.string "company", limit: 255
    t.string "street1", limit: 255
    t.string "street2", limit: 255
    t.string "city", limit: 255
    t.string "state", limit: 255
    t.string "zip", limit: 255
    t.string "country", limit: 255
    t.string "phone", limit: 255
    t.string "email", limit: 255
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["easy_post_id"], name: "public_refinery_shipping_addresses_easy_post_id1_idx"
    t.index ["position"], name: "public_refinery_shipping_addresses_position0_idx"
  end

  create_table "refinery_shipping_costs", id: :serial, force: :cascade do |t|
    t.integer "shipment_id"
    t.string "cost_type", limit: 255
    t.text "comments"
    t.string "currency_code", limit: 255
    t.decimal "amount", precision: 13, scale: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "invoice_amount", precision: 13, scale: 4
    t.index ["amount"], name: "public_refinery_shipping_costs_amount3_idx"
    t.index ["cost_type"], name: "public_refinery_shipping_costs_cost_type1_idx"
    t.index ["currency_code"], name: "public_refinery_shipping_costs_currency_code2_idx"
    t.index ["invoice_amount"], name: "public_refinery_shipping_costs_invoice_amount4_idx"
    t.index ["shipment_id"], name: "public_refinery_shipping_costs_shipment_id0_idx"
  end

  create_table "refinery_shipping_documents", id: :serial, force: :cascade do |t|
    t.integer "shipment_id"
    t.integer "resource_id"
    t.string "document_type", limit: 255
    t.text "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["document_type"], name: "public_refinery_shipping_documents_document_type2_idx"
    t.index ["resource_id"], name: "public_refinery_shipping_documents_resource_id1_idx"
    t.index ["shipment_id"], name: "public_refinery_shipping_documents_shipment_id0_idx"
  end

  create_table "refinery_shipping_items", id: :serial, force: :cascade do |t|
    t.integer "shipment_id"
    t.integer "order_id"
    t.string "order_label", limit: 255
    t.integer "order_item_id"
    t.string "article_code", limit: 255
    t.string "description", limit: 255
    t.string "hs_code_label", limit: 255
    t.boolean "partial_shipment", default: false, null: false
    t.decimal "qty", precision: 13, scale: 4
    t.integer "item_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["article_code"], name: "public_refinery_shipping_items_article_code4_idx"
    t.index ["description"], name: "public_refinery_shipping_items_description5_idx"
    t.index ["hs_code_label"], name: "public_refinery_shipping_items_hs_code_label6_idx"
    t.index ["item_order"], name: "public_refinery_shipping_items_item_order8_idx"
    t.index ["order_id"], name: "public_refinery_shipping_items_order_id1_idx"
    t.index ["order_item_id"], name: "public_refinery_shipping_items_order_item_id3_idx"
    t.index ["order_label"], name: "public_refinery_shipping_items_order_label2_idx"
    t.index ["partial_shipment"], name: "public_refinery_shipping_items_partial_shipment7_idx"
    t.index ["shipment_id"], name: "public_refinery_shipping_items_shipment_id0_idx"
  end

  create_table "refinery_shipping_locations", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.integer "owner_id"
    t.string "location_type", limit: 255
    t.boolean "airport", default: false, null: false
    t.boolean "railport", default: false, null: false
    t.boolean "roadport", default: false, null: false
    t.boolean "seaport", default: false, null: false
    t.string "location_code", limit: 255
    t.string "iata_code", limit: 255
    t.string "icao_code", limit: 255
    t.string "street1", limit: 255
    t.string "street2", limit: 255
    t.string "city", limit: 255
    t.string "state", limit: 255
    t.string "postal_code", limit: 255
    t.string "country", limit: 255
    t.string "country_code", limit: 255
    t.string "timezone", limit: 255
    t.decimal "lat", precision: 9, scale: 6
    t.decimal "lng", precision: 9, scale: 6
    t.string "customs_district_code", limit: 255
    t.datetime "confirmed_at"
    t.datetime "verified_at"
    t.datetime "archived_at"
    t.boolean "public", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["airport"], name: "public_refinery_shipping_locations_airport3_idx"
    t.index ["archived_at"], name: "public_refinery_shipping_locations_archived_at23_idx"
    t.index ["city"], name: "public_refinery_shipping_locations_city12_idx"
    t.index ["confirmed_at"], name: "public_refinery_shipping_locations_confirmed_at21_idx"
    t.index ["country"], name: "public_refinery_shipping_locations_country15_idx"
    t.index ["country_code"], name: "public_refinery_shipping_locations_country_code16_idx"
    t.index ["customs_district_code"], name: "public_refinery_shipping_locations_customs_district_code20_idx"
    t.index ["iata_code"], name: "public_refinery_shipping_locations_iata_code8_idx"
    t.index ["icao_code"], name: "public_refinery_shipping_locations_icao_code9_idx"
    t.index ["lat"], name: "public_refinery_shipping_locations_lat18_idx"
    t.index ["lng"], name: "public_refinery_shipping_locations_lng19_idx"
    t.index ["location_code"], name: "public_refinery_shipping_locations_location_code7_idx"
    t.index ["location_type"], name: "public_refinery_shipping_locations_location_type2_idx"
    t.index ["name"], name: "public_refinery_shipping_locations_name0_idx"
    t.index ["owner_id"], name: "public_refinery_shipping_locations_owner_id1_idx"
    t.index ["postal_code"], name: "public_refinery_shipping_locations_postal_code14_idx"
    t.index ["public"], name: "public_refinery_shipping_locations_public24_idx"
    t.index ["railport"], name: "public_refinery_shipping_locations_railport4_idx"
    t.index ["roadport"], name: "public_refinery_shipping_locations_roadport5_idx"
    t.index ["seaport"], name: "public_refinery_shipping_locations_seaport6_idx"
    t.index ["state"], name: "public_refinery_shipping_locations_state13_idx"
    t.index ["street1"], name: "public_refinery_shipping_locations_street110_idx"
    t.index ["street2"], name: "public_refinery_shipping_locations_street211_idx"
    t.index ["timezone"], name: "public_refinery_shipping_locations_timezone17_idx"
    t.index ["verified_at"], name: "public_refinery_shipping_locations_verified_at22_idx"
  end

  create_table "refinery_shipping_packages", id: :serial, force: :cascade do |t|
    t.integer "shipment_id"
    t.string "name", limit: 255
    t.string "package_type", limit: 255
    t.decimal "total_packages", precision: 13, scale: 4
    t.string "length_unit", limit: 255
    t.decimal "package_length", precision: 13, scale: 4
    t.decimal "package_width", precision: 13, scale: 4
    t.decimal "package_height", precision: 13, scale: 4
    t.string "volume_unit", limit: 255
    t.decimal "package_volume", precision: 13, scale: 4
    t.string "weight_unit", limit: 255
    t.decimal "package_gross_weight", precision: 13, scale: 4
    t.integer "package_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "package_net_weight", precision: 13, scale: 4
    t.index ["name"], name: "public_refinery_shipping_packages_name1_idx"
    t.index ["package_order"], name: "public_refinery_shipping_packages_package_order3_idx"
    t.index ["package_type"], name: "public_refinery_shipping_packages_package_type2_idx"
    t.index ["shipment_id"], name: "public_refinery_shipping_packages_shipment_id0_idx"
  end

  create_table "refinery_shipping_parcels", id: :serial, force: :cascade do |t|
    t.date "parcel_date"
    t.string "from_name", limit: 255
    t.integer "from_contact_id"
    t.string "courier", limit: 255
    t.string "air_waybill_no", limit: 255
    t.string "to_name", limit: 255
    t.integer "to_user_id"
    t.integer "shipping_document_id"
    t.boolean "receiver_signed", default: false, null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "received_by_id"
    t.integer "assigned_to_id"
    t.string "description", limit: 255
    t.index ["assigned_to_id"], name: "public_refinery_shipping_parcels_assigned_to_id6_idx"
    t.index ["from_contact_id"], name: "public_refinery_shipping_parcels_from_contact_id1_idx"
    t.index ["position"], name: "public_refinery_shipping_parcels_position0_idx"
    t.index ["received_by_id"], name: "public_refinery_shipping_parcels_received_by_id5_idx"
    t.index ["receiver_signed"], name: "public_refinery_shipping_parcels_receiver_signed4_idx"
    t.index ["shipping_document_id"], name: "public_refinery_shipping_parcels_shipping_document_id3_idx"
    t.index ["to_user_id"], name: "public_refinery_shipping_parcels_to_user_id2_idx"
  end

  create_table "refinery_shipping_routes", id: :serial, force: :cascade do |t|
    t.integer "shipment_id"
    t.integer "location_id"
    t.string "route_type", limit: 255
    t.string "route_description", limit: 255
    t.text "notes"
    t.string "status", limit: 255
    t.datetime "arrived_at"
    t.datetime "departed_at"
    t.integer "prior_route_id"
    t.boolean "final_destination", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["arrived_at"], name: "public_refinery_shipping_routes_arrived_at5_idx"
    t.index ["departed_at"], name: "public_refinery_shipping_routes_departed_at6_idx"
    t.index ["final_destination"], name: "public_refinery_shipping_routes_final_destination8_idx"
    t.index ["location_id"], name: "public_refinery_shipping_routes_location_id1_idx"
    t.index ["prior_route_id"], name: "public_refinery_shipping_routes_prior_route_id7_idx"
    t.index ["route_description"], name: "public_refinery_shipping_routes_route_description3_idx"
    t.index ["route_type"], name: "public_refinery_shipping_routes_route_type2_idx"
    t.index ["shipment_id"], name: "public_refinery_shipping_routes_shipment_id0_idx"
    t.index ["status"], name: "public_refinery_shipping_routes_status4_idx"
  end

  create_table "refinery_shipping_shipment_accounts", id: :serial, force: :cascade do |t|
    t.integer "contact_id"
    t.string "description", limit: 255
    t.string "courier", limit: 255
    t.string "account_no", limit: 255
    t.text "comments"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_no"], name: "public_refinery_shipping_shipment_accounts_account_no2_idx"
    t.index ["contact_id"], name: "public_refinery_shipping_shipment_accounts_contact_id0_idx"
    t.index ["courier"], name: "public_refinery_shipping_shipment_accounts_courier1_idx"
    t.index ["position"], name: "public_refinery_shipping_shipment_accounts_position3_idx"
  end

  create_table "refinery_shipping_shipment_parcels", id: :serial, force: :cascade do |t|
    t.integer "shipment_id"
    t.integer "length"
    t.integer "width"
    t.integer "height"
    t.integer "weight"
    t.string "predefined_package", limit: 255
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description", limit: 255
    t.integer "quantity", default: 0, null: false
    t.decimal "value", precision: 8, scale: 2
    t.string "origin_country", limit: 255
    t.string "contents_type", limit: 255
    t.index ["position"], name: "public_refinery_shipping_shipment_parcels_position0_idx"
  end

  create_table "refinery_shipping_shipments", id: :serial, force: :cascade do |t|
    t.integer "from_contact_id"
    t.integer "from_address_id"
    t.integer "to_contact_id"
    t.integer "to_address_id"
    t.integer "created_by_id"
    t.integer "assigned_to_id"
    t.string "courier_company_label", limit: 255
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bill_to_account_id"
    t.string "bill_to", limit: 255
    t.string "description", limit: 255
    t.string "label_url", limit: 255
    t.string "tracking_number", limit: 255
    t.string "tracking_status", limit: 255
    t.string "status", limit: 255
    t.string "easypost_object_id", limit: 255
    t.text "rates_content"
    t.string "rate_object_id", limit: 255
    t.string "rate_service", limit: 255
    t.decimal "rate_amount", precision: 13, scale: 4
    t.string "rate_currency", limit: 255
    t.date "etd_date"
    t.text "tracking_info"
    t.integer "project_id"
    t.string "code", limit: 255
    t.integer "receiver_company_id"
    t.integer "shipper_company_id"
    t.integer "consignee_company_id"
    t.integer "consignee_address_id"
    t.string "consignee_reference", limit: 255
    t.string "mode", limit: 255
    t.string "forwarder_company_label", limit: 255
    t.string "forwarder_booking_number", limit: 255
    t.string "comments", limit: 255
    t.integer "no_of_parcels"
    t.decimal "duty_amount", precision: 13, scale: 4
    t.decimal "terminal_fee_amount", precision: 13, scale: 4
    t.decimal "domestic_transportation_cost_amount", precision: 13, scale: 4
    t.decimal "forwarding_fee_amount", precision: 13, scale: 4
    t.decimal "freight_cost_amount", precision: 13, scale: 4
    t.decimal "volume_amount", precision: 13, scale: 4
    t.decimal "volume_manual_amount", precision: 13, scale: 4
    t.string "volume_unit", limit: 255
    t.decimal "gross_weight_amount", precision: 13, scale: 4
    t.decimal "gross_weight_manual_amount", precision: 13, scale: 4
    t.decimal "net_weight_amount", precision: 13, scale: 4
    t.decimal "net_weight_manual_amount", precision: 13, scale: 4
    t.decimal "chargeable_weight_amount", precision: 13, scale: 4
    t.decimal "chargeable_weight_manual_amount", precision: 13, scale: 4
    t.string "weight_unit", limit: 255
    t.string "from_contact_label", limit: 255
    t.string "shipper_company_label", limit: 255
    t.string "to_contact_label", limit: 255
    t.string "receiver_company_label", limit: 255
    t.string "consignee_company_label", limit: 255
    t.string "created_by_label", limit: 255
    t.string "assigned_to_label", limit: 255
    t.date "eta_date"
    t.integer "supplier_company_id"
    t.string "supplier_company_label", limit: 255
    t.integer "forwarder_company_id"
    t.string "load_port", limit: 255
    t.integer "courier_company_id"
    t.string "shipment_terms", limit: 255
    t.text "shipment_terms_details"
    t.datetime "archived_at"
    t.string "length_unit", limit: 255
    t.date "cargo_ready_date"
    t.integer "no_of_parcels_manual"
    t.index ["archived_at"], name: "public_refinery_shipping_shipments_archived_at35_idx"
    t.index ["assigned_to_id"], name: "public_refinery_shipping_shipments_assigned_to_id8_idx"
    t.index ["assigned_to_label"], name: "public_refinery_shipping_shipments_assigned_to_label23_idx"
    t.index ["bill_to_account_id"], name: "public_refinery_shipping_shipments_bill_to_account_id0_idx"
    t.index ["cargo_ready_date"], name: "public_refinery_shipping_shipments_cargo_ready_date36_idx"
    t.index ["code"], name: "public_refinery_shipping_shipments_code11_idx"
    t.index ["comments"], name: "public_refinery_shipping_shipments_comments17_idx"
    t.index ["consignee_address_id"], name: "public_refinery_shipping_shipments_consignee_address_id13_idx"
    t.index ["consignee_company_id"], name: "public_refinery_shipping_shipments_consignee_company_id12_idx"
    t.index ["consignee_company_label"], name: "public_refinery_shipping_shipments_consignee_company_label21_id"
    t.index ["consignee_reference"], name: "public_refinery_shipping_shipments_consignee_reference14_idx"
    t.index ["courier_company_id"], name: "public_refinery_shipping_shipments_courier_company_id33_idx"
    t.index ["created_by_id"], name: "public_refinery_shipping_shipments_created_by_id7_idx"
    t.index ["created_by_label"], name: "public_refinery_shipping_shipments_created_by_label22_idx"
    t.index ["easypost_object_id"], name: "public_refinery_shipping_shipments_easypost_object_id1_idx"
    t.index ["eta_date"], name: "public_refinery_shipping_shipments_eta_date24_idx"
    t.index ["forwarder_booking_number"], name: "public_refinery_shipping_shipments_forwarder_booking_number16_i"
    t.index ["forwarder_company_id"], name: "public_refinery_shipping_shipments_forwarder_company_id31_idx"
    t.index ["forwarder_company_label"], name: "public_refinery_shipping_shipments_forwarder_company_label32_id"
    t.index ["from_address_id"], name: "public_refinery_shipping_shipments_from_address_id4_idx"
    t.index ["from_contact_id"], name: "public_refinery_shipping_shipments_from_contact_id3_idx"
    t.index ["from_contact_label"], name: "public_refinery_shipping_shipments_from_contact_label19_idx"
    t.index ["mode"], name: "public_refinery_shipping_shipments_mode15_idx"
    t.index ["no_of_parcels"], name: "public_refinery_shipping_shipments_no_of_parcels18_idx"
    t.index ["no_of_parcels_manual"], name: "public_refinery_shipping_shipments_no_of_parcels_manual37_idx"
    t.index ["position"], name: "public_refinery_shipping_shipments_position2_idx"
    t.index ["project_id"], name: "public_refinery_shipping_shipments_project_id10_idx"
    t.index ["receiver_company_id"], name: "public_refinery_shipping_shipments_receiver_company_id27_idx"
    t.index ["receiver_company_label"], name: "public_refinery_shipping_shipments_receiver_company_label28_idx"
    t.index ["shipment_terms"], name: "public_refinery_shipping_shipments_shipment_terms34_idx"
    t.index ["shipper_company_id"], name: "public_refinery_shipping_shipments_shipper_company_id25_idx"
    t.index ["shipper_company_label"], name: "public_refinery_shipping_shipments_shipper_company_label26_idx"
    t.index ["status"], name: "public_refinery_shipping_shipments_status9_idx"
    t.index ["supplier_company_id"], name: "public_refinery_shipping_shipments_supplier_company_id29_idx"
    t.index ["supplier_company_label"], name: "public_refinery_shipping_shipments_supplier_company_label30_idx"
    t.index ["to_address_id"], name: "public_refinery_shipping_shipments_to_address_id6_idx"
    t.index ["to_contact_id"], name: "public_refinery_shipping_shipments_to_contact_id5_idx"
    t.index ["to_contact_label"], name: "public_refinery_shipping_shipments_to_contact_label20_idx"
  end

  create_table "refinery_shows", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "website", limit: 255
    t.integer "logo_id"
    t.text "description"
    t.text "msg_json_struct"
    t.datetime "last_sync_datetime"
    t.string "last_sync_result", limit: 255
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refinery_sick_leaves", id: :serial, force: :cascade do |t|
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
    t.index ["doctors_note_id"], name: "public_refinery_sick_leaves_doctors_note_id2_idx"
    t.index ["employee_id"], name: "public_refinery_sick_leaves_employee_id0_idx"
    t.index ["end_date"], name: "public_refinery_sick_leaves_end_date4_idx"
    t.index ["event_id"], name: "public_refinery_sick_leaves_event_id1_idx"
    t.index ["start_date"], name: "public_refinery_sick_leaves_start_date3_idx"
  end

  create_table "refinery_xero_accounts", id: :serial, force: :cascade do |t|
    t.string "guid", limit: 255
    t.string "code", limit: 255
    t.string "name", limit: 255
    t.string "account_type", limit: 255
    t.string "account_class", limit: 255
    t.string "status", limit: 255
    t.string "currency_code", limit: 255
    t.string "tax_type", limit: 255
    t.string "description", limit: 255
    t.string "system_account", limit: 255
    t.boolean "enable_payments_account"
    t.boolean "show_in_expense_claims"
    t.string "bank_account_number", limit: 255
    t.string "reporting_code", limit: 255
    t.string "reporting_code_name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "inactive", default: false, null: false
    t.boolean "featured", default: false, null: false
    t.text "when_to_use"
    t.index ["featured"], name: "public_refinery_xero_accounts_featured2_idx"
    t.index ["guid"], name: "public_refinery_xero_accounts_guid0_idx"
    t.index ["inactive"], name: "public_refinery_xero_accounts_inactive1_idx"
  end

  create_table "refinery_xero_api_keyfiles", id: :serial, force: :cascade do |t|
    t.string "organisation", limit: 255
    t.text "key_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "consumer_key", limit: 255
    t.string "consumer_secret", limit: 255
    t.string "encryption_key", limit: 255
    t.index ["organisation"], name: "public_refinery_xero_api_keyfiles_organisation0_idx"
  end

  create_table "refinery_xero_contacts", id: :serial, force: :cascade do |t|
    t.string "guid", limit: 255
    t.string "contact_number", limit: 255
    t.string "contact_status", limit: 255
    t.string "name", limit: 255
    t.string "tax_number", limit: 255
    t.string "bank_account_details", limit: 255
    t.string "accounts_receivable_tax_type", limit: 255
    t.string "accounts_payable_tax_type", limit: 255
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "email_address", limit: 255
    t.string "skype_user_name", limit: 255
    t.string "contact_groups", limit: 255
    t.string "default_currency", limit: 255
    t.datetime "updated_date_utc"
    t.boolean "is_supplier", default: false, null: false
    t.boolean "is_customer", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "inactive", default: false, null: false
    t.index ["guid"], name: "public_refinery_xero_contacts_guid0_idx"
    t.index ["inactive"], name: "public_refinery_xero_contacts_inactive1_idx"
  end

  create_table "refinery_xero_expense_claim_attachments", id: :serial, force: :cascade do |t|
    t.integer "xero_expense_claim_id"
    t.integer "resource_id"
    t.string "guid", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "public_refinery_xero_expense_claim_attachments_guid2_idx"
    t.index ["resource_id"], name: "public_refinery_xero_expense_claim_attachments_resource_id1_idx"
    t.index ["xero_expense_claim_id"], name: "public_refinery_xero_expense_claim_attachments_xero_expense_cla"
  end

  create_table "refinery_xero_expense_claims", id: :serial, force: :cascade do |t|
    t.integer "employee_id"
    t.string "description", limit: 255
    t.string "guid", limit: 255
    t.string "status", limit: 255
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "amount_due", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "amount_paid", precision: 10, scale: 2, default: "0.0", null: false
    t.date "payment_due_date"
    t.date "reporting_date"
    t.datetime "updated_date_utc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "added_by_id"
    t.string "error_reason", limit: 255
    t.index ["added_by_id"], name: "public_refinery_xero_expense_claims_added_by_id3_idx"
    t.index ["employee_id"], name: "public_refinery_xero_expense_claims_employee_id0_idx"
    t.index ["guid"], name: "public_refinery_xero_expense_claims_guid1_idx"
    t.index ["updated_date_utc"], name: "public_refinery_xero_expense_claims_updated_date_utc2_idx"
  end

  create_table "refinery_xero_line_items", id: :serial, force: :cascade do |t|
    t.integer "xero_receipt_id"
    t.integer "xero_account_id"
    t.string "item_code", limit: 255
    t.string "description", limit: 255
    t.decimal "quantity", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "unit_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.string "account_code", limit: 255
    t.string "tax_type", limit: 255
    t.decimal "tax_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "line_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "discount_rate", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "tracking_categories_and_options"
    t.index ["xero_account_id"], name: "public_refinery_xero_line_items_xero_account_id1_idx"
    t.index ["xero_receipt_id"], name: "public_refinery_xero_line_items_xero_receipt_id0_idx"
  end

  create_table "refinery_xero_receipts", id: :serial, force: :cascade do |t|
    t.integer "employee_id"
    t.integer "xero_expense_claim_id"
    t.string "guid", limit: 255
    t.string "receipt_number", limit: 255
    t.string "reference", limit: 255
    t.string "status", limit: 255
    t.string "line_amount_types", limit: 255
    t.decimal "sub_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_tax", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.date "date"
    t.string "url", limit: 255
    t.boolean "has_attachments", default: false, null: false
    t.datetime "updated_date_utc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "xero_contact_id"
    t.index ["employee_id"], name: "public_refinery_xero_receipts_employee_id0_idx"
    t.index ["guid"], name: "public_refinery_xero_receipts_guid2_idx"
    t.index ["updated_date_utc"], name: "public_refinery_xero_receipts_updated_date_utc3_idx"
    t.index ["xero_contact_id"], name: "public_refinery_xero_receipts_xero_contact_id4_idx"
    t.index ["xero_expense_claim_id"], name: "public_refinery_xero_receipts_xero_expense_claim_id1_idx"
  end

  create_table "refinery_xero_tracking_categories", id: :serial, force: :cascade do |t|
    t.string "guid", limit: 255
    t.string "name", limit: 255
    t.string "status", limit: 255
    t.text "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "public_refinery_xero_tracking_categories_guid0_idx"
    t.index ["name"], name: "public_refinery_xero_tracking_categories_name1_idx"
    t.index ["status"], name: "public_refinery_xero_tracking_categories_status2_idx"
  end

  create_table "rest_hooks", force: :cascade do |t|
    t.bigint "user_id"
    t.string "event_name", limit: 255
    t.string "hook_url", limit: 255
    t.text "scope"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_name"], name: "public_rest_hooks_event_name1_idx"
    t.index ["hook_url"], name: "public_rest_hooks_hook_url2_idx"
    t.index ["user_id"], name: "public_rest_hooks_user_id0_idx"
  end

  create_table "seo_meta", id: :serial, force: :cascade do |t|
    t.integer "seo_meta_id"
    t.string "seo_meta_type", limit: 255
    t.string "browser_title", limit: 255
    t.text "meta_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "public_seo_meta_id0_idx"
    t.index ["seo_meta_id", "seo_meta_type"], name: "public_seo_meta_seo_meta_id1_idx"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type", limit: 255
    t.integer "taggable_id"
    t.string "tagger_type", limit: 255
    t.integer "tagger_id"
    t.string "context", limit: 255
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "public_taggings_tag_id0_idx", unique: true
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "public_tags_name0_idx", unique: true
  end

  create_table "user_settings", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "identifier", limit: 255
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "public_user_settings_identifier1_idx"
    t.index ["user_id"], name: "public_user_settings_user_id0_idx"
  end

  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id", name: "oauth_access_grants_application_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id", name: "oauth_access_tokens_application_id_fkey", on_update: :restrict, on_delete: :restrict
end
