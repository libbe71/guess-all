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

ActiveRecord::Schema[7.1].define(version: 2025_02_06_183731) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friends", force: :cascade do |t|
    t.bigint "user1_id"
    t.bigint "user2_id"
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user1_id"], name: "index_friends_on_user1_id"
    t.index ["user2_id"], name: "index_friends_on_user2_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "player1_id", null: false
    t.bigint "player2_id"
    t.string "status", default: "pending", null: false
    t.bigint "winner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "player1_choosen_character"
    t.string "player2_choosen_character"
    t.bigint "round_id", null: false
    t.string "player1_characters_discarded"
    t.string "player2_characters_discarded"
    t.index ["player1_id"], name: "index_games_on_player1_id"
    t.index ["player2_id"], name: "index_games_on_player2_id"
    t.index ["round_id"], name: "index_games_on_round_id"
    t.index ["winner_id"], name: "index_games_on_winner_id"
  end

  create_table "moves", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.string "question", null: false
    t.string "answer", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["game_id"], name: "index_moves_on_game_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email_address", null: false
    t.string "twitter_id"
    t.string "password_digest", null: false
    t.string "locale"
    t.string "theme"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["twitter_id"], name: "index_users_on_twitter_id", unique: true, where: "(twitter_id IS NOT NULL)"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "friends", "users", column: "user1_id", on_delete: :cascade
  add_foreign_key "friends", "users", column: "user2_id", on_delete: :cascade
  add_foreign_key "games", "users", column: "player1_id", on_delete: :cascade
  add_foreign_key "games", "users", column: "player2_id", on_delete: :cascade
  add_foreign_key "games", "users", column: "round_id", on_delete: :cascade
  add_foreign_key "games", "users", column: "winner_id", on_delete: :cascade
  add_foreign_key "moves", "games", on_delete: :cascade
  add_foreign_key "moves", "users", on_delete: :cascade
end
