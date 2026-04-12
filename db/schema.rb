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

ActiveRecord::Schema[7.1].define(version: 2026_04_12_125735) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.date "booking_date"
    t.string "status", default: "pending", null: false
    t.bigint "user_id", null: false
    t.bigint "time_slot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "score", precision: 4, scale: 1
    t.bigint "partner_user_id"
    t.string "stripe_session_id"
    t.string "stripe_payment_intent_id"
    t.index ["partner_user_id"], name: "index_bookings_on_partner_user_id"
    t.index ["stripe_payment_intent_id"], name: "index_bookings_on_stripe_payment_intent_id"
    t.index ["stripe_session_id"], name: "index_bookings_on_stripe_session_id"
    t.index ["time_slot_id"], name: "index_bookings_on_time_slot_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "friend_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
  end

  create_table "scheduled_sessions", force: :cascade do |t|
    t.date "date"
    t.decimal "price", precision: 5, scale: 2
    t.bigint "location_id", null: false
    t.bigint "session_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_scheduled_sessions_on_location_id"
    t.index ["session_type_id"], name: "index_scheduled_sessions_on_session_type_id"
  end

  create_table "session_types", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_slots", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "capacity"
    t.bigint "scheduled_session_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scheduled_session_id"], name: "index_time_slots_on_scheduled_session_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "time_slots"
  add_foreign_key "bookings", "users"
  add_foreign_key "bookings", "users", column: "partner_user_id"
  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
  add_foreign_key "scheduled_sessions", "locations"
  add_foreign_key "scheduled_sessions", "session_types"
  add_foreign_key "time_slots", "scheduled_sessions"
end
