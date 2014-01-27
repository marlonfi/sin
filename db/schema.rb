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

ActiveRecord::Schema.define(version: 20140127182641) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "imports", force: true do |t|
    t.string   "tipo_clase"
    t.date     "fecha_pago"
    t.string   "responsable"
    t.string   "archivo"
    t.string   "descripcion"
    t.string   "formato_org"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "imports", ["tipo_clase", "fecha_pago", "created_at"], name: "index_imports_on_tipo_clase_and_fecha_pago_and_created_at", using: :btree

  create_table "red_asistencials", force: true do |t|
    t.string   "cod_essalud"
    t.string   "nombre"
    t.string   "contacto_nombre"
    t.string   "contacto_telefono"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "red_asistencials", ["cod_essalud"], name: "index_red_asistencials_on_cod_essalud", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

end
