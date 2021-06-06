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

ActiveRecord::Schema.define(version: 2018_05_30_022357) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "achivements", force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.text "description"
    t.integer "points"
    t.integer "kind"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "ads", force: :cascade do |t|
    t.string "title"
    t.string "image"
    t.text "content"
    t.string "link"
    t.integer "views_count", default: 0
    t.integer "clicks_count", default: 0
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "client_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ad_type"
    t.index ["client_id"], name: "index_ads_on_client_id"
  end

  create_table "ads_settings", force: :cascade do |t|
    t.boolean "use_adsense"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "authentication_providers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_name_on_authentication_providers"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "color"
    t.string "subject"
    t.boolean "for_news"
    t.string "synonims", default: ""
    t.string "hex_color", default: "#0F6A37"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.bigint "department_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["department_id"], name: "index_cities_on_department_id"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "contact"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "commodities", force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "priority"
  end

  create_table "consult_answer_images", force: :cascade do |t|
    t.bigint "consult_answer_id"
    t.string "source"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consult_answer_id"], name: "index_consult_answer_images_on_consult_answer_id"
  end

  create_table "consult_answers", force: :cascade do |t|
    t.text "text"
    t.bigint "user_id"
    t.bigint "consult_question_id"
    t.integer "points"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consult_question_id"], name: "index_consult_answers_on_consult_question_id"
    t.index ["user_id"], name: "index_consult_answers_on_user_id"
  end

  create_table "consult_categories", force: :cascade do |t|
    t.string "name"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "consult_question_images", force: :cascade do |t|
    t.bigint "consult_question_id"
    t.string "source"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consult_question_id"], name: "index_consult_question_images_on_consult_question_id"
  end

  create_table "consult_questions", force: :cascade do |t|
    t.text "text"
    t.bigint "user_id"
    t.integer "points"
    t.integer "visits_count"
    t.bigint "consult_category_id"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consult_category_id"], name: "index_consult_questions_on_consult_category_id"
    t.index ["user_id"], name: "index_consult_questions_on_user_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "flag"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.bigint "country_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_departments_on_country_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "token"
    t.string "platform"
    t.bigint "user_id"
    t.string "imei"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "publication_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["publication_id"], name: "index_favorites_on_publication_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "publication_id"
    t.string "subject"
    t.text "details"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "resolution"
    t.index ["publication_id"], name: "index_feedbacks_on_publication_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "information", force: :cascade do |t|
    t.string "logo"
    t.string "facebook_link"
    t.string "twitter_link"
    t.string "linkedin_link"
    t.string "youtube_link"
    t.string "instagram_link"
    t.string "googleplus_link"
    t.string "meta_image"
    t.string "meta_description"
    t.string "meta_keywords"
    t.string "blog_tab_title"
    t.string "blog_sidebar_title"
    t.string "about_us_image"
    t.string "about_us_title"
    t.text "about_us_content"
    t.string "copyrights_text"
    t.text "terms"
    t.text "policy"
    t.text "habeasdata"
    t.string "contact_email"
    t.string "contact_address"
    t.string "contact_phone"
    t.string "register_image"
    t.string "register_title"
    t.text "register_content"
    t.string "login_image"
    t.string "login_title"
    t.text "login_content"
    t.string "explanation_image"
    t.string "explanation_title"
    t.text "explanation_content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "small_logo"
  end

  create_table "interest_categories", force: :cascade do |t|
    t.bigint "interest_id"
    t.bigint "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_interest_categories_on_category_id"
    t.index ["interest_id"], name: "index_interest_categories_on_interest_id"
  end

  create_table "interests", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "levels", force: :cascade do |t|
    t.string "name"
    t.integer "min"
    t.integer "max"
    t.integer "number"
    t.text "description"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "receiver_id"
    t.text "text"
    t.string "file"
    t.string "tmp_id"
    t.boolean "read"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id"
    t.text "text"
    t.boolean "read"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "email_engaged"
    t.integer "object_id"
    t.string "object_type"
    t.string "link"
    t.boolean "arrived", default: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.integer "visibility_level"
    t.boolean "unlimited_time"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "points"
    t.string "icon"
    t.string "color"
    t.text "description"
    t.integer "priority"
  end

  create_table "post_subcategories", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "subcategory_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_post_subcategories_on_post_id"
    t.index ["subcategory_id"], name: "index_post_subcategories_on_subcategory_id"
  end

  create_table "post_tags", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "tag_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_post_tags_on_post_id"
    t.index ["tag_id"], name: "index_post_tags_on_tag_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "image"
    t.string "video"
    t.text "abstract"
    t.text "content"
    t.date "date"
    t.boolean "is_news"
    t.integer "status"
    t.string "author"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.integer "views_count", default: 0
    t.string "scope_location"
    t.text "facebook_comments_link"
    t.bigint "country_id"
    t.string "video_file"
    t.text "content2"
    t.index ["country_id"], name: "index_posts_on_country_id"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
  end

  create_table "publication_images", force: :cascade do |t|
    t.string "source"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "publication_id"
    t.index ["publication_id"], name: "index_publication_images_on_publication_id"
  end

  create_table "publication_questions", force: :cascade do |t|
    t.bigint "publication_id"
    t.bigint "user_id"
    t.text "question"
    t.text "answer"
    t.datetime "answer_time"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["publication_id"], name: "index_publication_questions_on_publication_id"
    t.index ["user_id"], name: "index_publication_questions_on_user_id"
  end

  create_table "publication_tags", force: :cascade do |t|
    t.bigint "publication_id"
    t.bigint "tag_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["publication_id"], name: "index_publication_tags_on_publication_id"
    t.index ["tag_id"], name: "index_publication_tags_on_tag_id"
  end

  create_table "publications", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "content"
    t.integer "kind"
    t.integer "mode"
    t.float "price"
    t.integer "units"
    t.integer "status"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.date "start_date"
    t.date "end_date"
    t.float "shipping_price"
    t.bigint "city_id"
    t.string "address"
    t.bigint "plan_id"
    t.string "subject"
    t.bigint "subcategory_id"
    t.integer "step"
    t.integer "year"
    t.string "brand"
    t.integer "km"
    t.string "model"
    t.string "transmission"
    t.integer "cylinder"
    t.string "color"
    t.string "fuel_type"
    t.string "number"
    t.float "total_mtr"
    t.float "builded_mtr"
    t.integer "estrato"
    t.float "admin_price"
    t.string "characteristics"
    t.boolean "shipping"
    t.boolean "warranty"
    t.text "warranty_description"
    t.integer "visits_count", default: 0
    t.boolean "with_ac"
    t.boolean "uniq_owner"
    t.boolean "to_agree"
    t.boolean "willing_to_move"
    t.boolean "for_adoption"
    t.boolean "is_lot"
    t.integer "lot_size"
    t.string "age"
    t.boolean "pickup"
    t.boolean "in_need"
    t.string "video"
    t.string "measure_unit"
    t.index ["city_id"], name: "index_publications_on_city_id"
    t.index ["plan_id"], name: "index_publications_on_plan_id"
    t.index ["slug"], name: "index_publications_on_slug", unique: true
    t.index ["subcategory_id"], name: "index_publications_on_subcategory_id"
    t.index ["user_id"], name: "index_publications_on_user_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "publication_id"
    t.bigint "user_id"
    t.integer "status"
    t.text "review"
    t.integer "received"
    t.integer "recommended"
    t.string "address"
    t.bigint "city_id"
    t.string "phone"
    t.boolean "shipping"
    t.integer "units"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "consult"
    t.boolean "delivered"
    t.integer "buyer_recommended"
    t.text "buyer_review"
    t.boolean "reviewed"
    t.boolean "buyer_reviewed"
    t.float "price"
    t.boolean "send_status"
    t.boolean "charge_status"
    t.boolean "pay_status"
    t.index ["city_id"], name: "index_purchases_on_city_id"
    t.index ["publication_id"], name: "index_purchases_on_publication_id"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "subcategories", force: :cascade do |t|
    t.string "name"
    t.bigint "category_id"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "synonims", default: ""
    t.index ["category_id"], name: "index_subcategories_on_category_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "terms_versions", force: :cascade do |t|
    t.text "terms"
    t.string "version"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_achivements", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "achivement_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "points"
    t.index ["achivement_id"], name: "index_user_achivements_on_achivement_id"
    t.index ["user_id"], name: "index_user_achivements_on_user_id"
  end

  create_table "user_authentications", force: :cascade do |t|
    t.integer "user_id"
    t.integer "authentication_provider_id"
    t.string "uid"
    t.string "token"
    t.datetime "token_expires_at"
    t.text "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authentication_provider_id"], name: "index_user_authentications_on_authentication_provider_id"
    t.index ["user_id"], name: "index_user_authentications_on_user_id"
  end

  create_table "user_consult_answer_votes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "consult_answer_id"
    t.integer "points"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consult_answer_id"], name: "index_user_consult_answer_votes_on_consult_answer_id"
    t.index ["user_id"], name: "index_user_consult_answer_votes_on_user_id"
  end

  create_table "user_consult_question_visits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "consult_question_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consult_question_id"], name: "index_user_consult_question_visits_on_consult_question_id"
    t.index ["user_id"], name: "index_user_consult_question_visits_on_user_id"
  end

  create_table "user_consult_question_votes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "consult_question_id"
    t.integer "points"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consult_question_id"], name: "index_user_consult_question_votes_on_consult_question_id"
    t.index ["user_id"], name: "index_user_consult_question_votes_on_user_id"
  end

  create_table "user_contacts", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "interested_id"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "closed", default: false
    t.index ["user_id"], name: "index_user_contacts_on_user_id"
  end

  create_table "user_interests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "interest_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["interest_id"], name: "index_user_interests_on_interest_id"
    t.index ["user_id"], name: "index_user_interests_on_user_id"
  end

  create_table "user_visits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "publication_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["publication_id"], name: "index_user_visits_on_publication_id"
    t.index ["user_id"], name: "index_user_visits_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.date "birthdate"
    t.bigint "city_id"
    t.string "profession"
    t.string "phone"
    t.string "address"
    t.string "main_activity"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.bigint "level_id"
    t.string "image"
    t.integer "current_points", default: 0
    t.boolean "is_official"
    t.boolean "is_certified"
    t.string "nickname"
    t.string "authentication_token", limit: 30
    t.bigint "country_id"
    t.boolean "consult_manager", default: false
    t.string "gender"
    t.integer "likes", default: 0
    t.integer "dislikes", default: 0
    t.boolean "receive_notifications", default: true
    t.boolean "receive_email_ads", default: true
    t.boolean "terms_accepted", default: false
    t.string "terms_version_accepted", default: "1.0"
    t.boolean "last_terms_notified", default: false
    t.datetime "deleted_at"
    t.datetime "last_terms_notified_at"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["country_id"], name: "index_users_on_country_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["level_id"], name: "index_users_on_level_id"
    t.index ["nickname"], name: "index_users_on_nickname"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "variations", force: :cascade do |t|
    t.float "value"
    t.date "date"
    t.integer "status"
    t.bigint "commodity_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "currency"
    t.index ["commodity_id"], name: "index_variations_on_commodity_id"
  end

  add_foreign_key "ads", "clients"
  add_foreign_key "cities", "departments"
  add_foreign_key "consult_answer_images", "consult_answers"
  add_foreign_key "consult_answers", "consult_questions"
  add_foreign_key "consult_answers", "users"
  add_foreign_key "consult_question_images", "consult_questions"
  add_foreign_key "consult_questions", "consult_categories"
  add_foreign_key "consult_questions", "users"
  add_foreign_key "departments", "countries"
  add_foreign_key "devices", "users"
  add_foreign_key "favorites", "publications"
  add_foreign_key "favorites", "users"
  add_foreign_key "feedbacks", "publications"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "interest_categories", "categories"
  add_foreign_key "interest_categories", "interests"
  add_foreign_key "notifications", "users"
  add_foreign_key "post_subcategories", "posts"
  add_foreign_key "post_subcategories", "subcategories"
  add_foreign_key "post_tags", "posts"
  add_foreign_key "post_tags", "tags"
  add_foreign_key "posts", "countries"
  add_foreign_key "publication_images", "publications"
  add_foreign_key "publication_questions", "publications"
  add_foreign_key "publication_questions", "users"
  add_foreign_key "publication_tags", "publications"
  add_foreign_key "publication_tags", "tags"
  add_foreign_key "publications", "cities"
  add_foreign_key "publications", "plans"
  add_foreign_key "publications", "subcategories"
  add_foreign_key "publications", "users"
  add_foreign_key "purchases", "cities"
  add_foreign_key "purchases", "publications"
  add_foreign_key "purchases", "users"
  add_foreign_key "subcategories", "categories"
  add_foreign_key "user_achivements", "achivements"
  add_foreign_key "user_achivements", "users"
  add_foreign_key "user_consult_answer_votes", "consult_answers"
  add_foreign_key "user_consult_answer_votes", "users"
  add_foreign_key "user_consult_question_visits", "consult_questions"
  add_foreign_key "user_consult_question_visits", "users"
  add_foreign_key "user_consult_question_votes", "consult_questions"
  add_foreign_key "user_consult_question_votes", "users"
  add_foreign_key "user_contacts", "users"
  add_foreign_key "user_interests", "interests"
  add_foreign_key "user_interests", "users"
  add_foreign_key "user_visits", "publications"
  add_foreign_key "user_visits", "users"
  add_foreign_key "users", "cities"
  add_foreign_key "users", "countries"
  add_foreign_key "users", "levels"
  add_foreign_key "variations", "commodities"
end
