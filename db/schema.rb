# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_10_02_230928) do

  create_table "parcel_owners", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_parcel_owners_on_username", unique: true
  end

  create_table "parcels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "parcel_owner_id"
    t.decimal "weight", precision: 16, scale: 2
    t.decimal "volume", precision: 16, scale: 2
    t.string "aasm_state"
    t.decimal "shipping_cost", precision: 16, scale: 2
    t.bigint "train_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["aasm_state"], name: "index_parcels_on_aasm_state"
    t.index ["parcel_owner_id"], name: "index_parcels_on_parcel_owner_id"
    t.index ["train_id"], name: "index_parcels_on_train_id"
  end

  create_table "tracks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "track_no"
    t.string "aasm_state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["aasm_state"], name: "index_tracks_on_aasm_state"
    t.index ["track_no"], name: "index_tracks_on_track_no", unique: true
  end

  create_table "tracks_trains", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "track_id"
    t.bigint "train_id"
    t.index ["track_id"], name: "index_tracks_trains_on_track_id"
    t.index ["train_id"], name: "index_tracks_trains_on_train_id"
  end

  create_table "train_operators", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_train_operators_on_username", unique: true
  end

  create_table "trains", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "train_operator_id"
    t.string "train_no"
    t.decimal "total_cost", precision: 16, scale: 2
    t.decimal "total_weight", precision: 16, scale: 2
    t.decimal "total_volume", precision: 16, scale: 2
    t.string "aasm_state"
    t.integer "depart_track_id"
    t.datetime "depart_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["aasm_state"], name: "index_trains_on_aasm_state"
    t.index ["depart_track_id"], name: "index_trains_on_depart_track_id"
    t.index ["train_no"], name: "index_trains_on_train_no", unique: true
    t.index ["train_operator_id"], name: "index_trains_on_train_operator_id"
  end

end
