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

ActiveRecord::Schema[7.0].define(version: 2023_10_23_134348) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analytic_experiments", force: :cascade do |t|
    t.string "key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "device_experiment_options", force: :cascade do |t|
    t.bigint "experiment_option_id", null: false
    t.bigint "device_token_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_token_id"], name: "index_device_experiment_options_on_device_token_id"
    t.index ["experiment_option_id"], name: "index_device_experiment_options_on_experiment_option_id"
  end

  create_table "device_experiments", force: :cascade do |t|
    t.bigint "analytic_experiment_id", null: false
    t.bigint "device_token_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["analytic_experiment_id"], name: "index_device_experiments_on_analytic_experiment_id"
    t.index ["device_token_id"], name: "index_device_experiments_on_device_token_id"
  end

  create_table "device_tokens", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "experiment_options", force: :cascade do |t|
    t.string "name"
    t.string "experiment_name"
    t.integer "device_count_in_option", default: 0
    t.integer "device_count_in_experiment", default: 0
    t.float "limit_percentage", default: 0.0
    t.float "filling_percentage", default: 0.0
    t.boolean "open_for_addition", default: true
    t.bigint "analytic_experiment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["analytic_experiment_id"], name: "index_experiment_options_on_analytic_experiment_id"
  end

  add_foreign_key "device_experiment_options", "device_tokens"
  add_foreign_key "device_experiment_options", "experiment_options"
  add_foreign_key "device_experiments", "analytic_experiments"
  add_foreign_key "device_experiments", "device_tokens"
  add_foreign_key "experiment_options", "analytic_experiments"
end
