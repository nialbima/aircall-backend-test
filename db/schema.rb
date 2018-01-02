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

ActiveRecord::Schema.define(version: 20180102194839) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calls", force: :cascade do |t|
    t.string "twilio_sid"
    t.string "audio_url"
    t.string "status"
    t.string "called_number"
    t.string "called_country"
    t.string "called_zip"
    t.string "called_city"
    t.string "caller_number"
    t.string "caller_country"
    t.string "caller_zip"
    t.string "caller_city"
    t.integer "duration"
    t.datetime "opened_at"
    t.datetime "closed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["twilio_sid"], name: "index_calls_on_twilio_sid"
  end

end
