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

ActiveRecord::Schema[7.0].define(version: 2024_12_03_144414) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "full_domain"
    t.string "time_zone"
    t.string "plan_features"
    t.integer "account_type"
    t.jsonb "contact_info", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_secret"
    t.index ["full_domain"], name: "index_accounts_on_full_domain", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
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
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "agent_appointments", force: :cascade do |t|
    t.bigint "agent_id"
    t.bigint "appointment_id"
    t.bigint "account_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "checkin_at", precision: nil
    t.datetime "checkout_at", precision: nil
  end

  create_table "allowlisted_jwts", force: :cascade do |t|
    t.string "jti"
    t.string "aud"
    t.integer "session_type"
    t.datetime "exp", precision: nil
    t.bigint "account_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "allowlisted_jwt_id"
    t.index ["account_id", "jti"], name: "index_allowlisted_jwts_on_account_id_and_jti", unique: true
    t.index ["account_id", "user_id"], name: "index_allowlisted_jwts_on_account_id_and_user_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "account_id"
    t.jsonb "other_info"
    t.text "notes"
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "recurring"
    t.bigint "recurring_task_id"
    t.bigint "created_by_id"
    t.integer "appt_status", default: 1
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at", precision: nil
    t.datetime "locked_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "account_id"
    t.bigint "job_owner_id"
    t.string "job_owner_type"
    t.index ["account_id"], name: "index_delayed_jobs_on_account_id"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "domain_mappings", primary_key: "account_id", force: :cascade do |t|
    t.string "domain"
    t.index ["domain"], name: "index_domain_mappings_on_domain", unique: true
  end

  create_table "feedbacks", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "agent_id"
    t.bigint "account_id"
    t.jsonb "other_info"
    t.text "description"
    t.bigint "appointment_id"
    t.integer "note_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id"
    t.text "description"
    t.integer "group_type"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "holidays", force: :cascade do |t|
    t.bigint "agent_id"
    t.bigint "account_id"
    t.text "reason"
    t.datetime "from_time", precision: nil
    t.datetime "to_time", precision: nil
    t.integer "leave_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoice_items", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.date "date"
    t.decimal "quantity"
    t.string "description"
    t.decimal "unitPrice"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "invoiceId"
    t.string "clientId"
    t.string "groupId"
    t.string "regionId"
    t.string "timePeriod"
    t.integer "durationtype"
    t.integer "customizedCheckbox"
    t.decimal "ratePerMinute"
    t.datetime "invoiceDate"
    t.integer "account_id"
    t.decimal "grand_totalamount"
    t.decimal "grand_total_minutes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "agent_id"
    t.bigint "client_id"
    t.text "data"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "appointment_id"
  end

  create_table "recurring_tasks", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "account_id"
    t.jsonb "other_info"
    t.text "notes"
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "task_end_date", precision: nil
    t.bigint "created_by_id"
  end

  create_table "regions", force: :cascade do |t|
    t.bigint "account_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "address"
    t.string "phone"
    t.string "email"
    t.text "other_info"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "privileges"
    t.text "description"
    t.boolean "fc_default", default: false
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "salaries", force: :cascade do |t|
    t.string "salary_id"
    t.string "carer_id"
    t.string "group_id"
    t.string "region_id"
    t.string "time_period"
    t.boolean "customized_checkbox"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "salary_slab_inputs", force: :cascade do |t|
    t.bigint "salary_id", null: false
    t.string "slab_id", null: false
    t.decimal "rate", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["salary_id"], name: "index_salary_slab_inputs_on_salary_id"
  end

  create_table "shard_mappings", force: :cascade do |t|
    t.string "shard_name"
    t.integer "status"
    t.string "pod_info"
    t.string "region"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "mobile"
    t.string "privileges", default: "0"
    t.bigint "account_id"
    t.string "time_zone"
    t.string "type", default: "User"
    t.string "single_access_token"
    t.boolean "active", default: false, null: false
    t.boolean "deleted", default: false
    t.datetime "deleted_at", precision: nil
    t.boolean "whitelisted", default: false
    t.string "encrypted_password", default: "", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "other_info"
    t.text "region_ids", default: [], array: true
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.bigint "group_id"
    t.index ["account_id", "confirmation_token"], name: "index_users_on_account_id_and_confirmation_token", unique: true
    t.index ["account_id", "email"], name: "index_users_on_account_id_and_email", unique: true
    t.index ["account_id", "reset_password_token"], name: "index_users_on_account_id_and_reset_password_token", unique: true
    t.index ["account_id", "unlock_token"], name: "index_users_on_account_id_and_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "salary_slab_inputs", "salaries"
end
