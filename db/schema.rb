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

ActiveRecord::Schema.define(version: 20140225161016) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bases", force: true do |t|
    t.string   "codigo_base"
    t.string   "nombre_base"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bases", ["codigo_base"], name: "index_bases_on_codigo_base", using: :btree

  create_table "bitacoras", force: true do |t|
    t.integer  "enfermera_id"
    t.string   "tipo"
    t.integer  "import_id"
    t.string   "status"
    t.string   "ente_inicio"
    t.string   "ente_fin"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bitacoras", ["enfermera_id", "tipo", "status"], name: "index_bitacoras_on_enfermera_id_and_tipo_and_status", using: :btree

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

  create_table "enfermeras", force: true do |t|
    t.integer  "ente_id"
    t.string   "cod_planilla"
    t.string   "apellido_paterno"
    t.string   "apellido_materno"
    t.string   "nombres"
    t.string   "email"
    t.string   "regimen"
    t.boolean  "b_sinesss"
    t.boolean  "b_fedcut"
    t.boolean  "b_famesalud"
    t.boolean  "b_excel"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dni"
    t.string   "full_name"
    t.string   "sexo"
    t.string   "factor_sanguineo"
    t.date     "fecha_nacimiento"
    t.string   "domicilio_completo"
    t.string   "telefono"
    t.date     "fecha_inscripcion_sinesss"
    t.date     "fecha_ingreso_essalud"
    t.string   "photo"
  end

  add_index "enfermeras", ["ente_id", "cod_planilla", "b_sinesss"], name: "index_enfermeras_on_ente_id_and_cod_planilla_and_b_sinesss", using: :btree
  add_index "enfermeras", ["full_name"], name: "index_enfermeras_on_full_name", using: :btree

  create_table "entes", force: true do |t|
    t.integer  "red_asistencial_id"
    t.integer  "base_id"
    t.string   "cod_essalud"
    t.string   "nombre"
    t.string   "contacto_nombre"
    t.string   "contacto_numero"
    t.string   "direccion"
    t.float    "latitud"
    t.float    "longitud"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entes", ["red_asistencial_id", "base_id", "cod_essalud"], name: "index_entes_on_red_asistencial_id_and_base_id_and_cod_essalud", using: :btree

  create_table "imports", force: true do |t|
    t.string   "tipo_clase"
    t.date     "fecha_pago"
    t.string   "responsable"
    t.string   "archivo"
    t.string   "descripcion"
    t.string   "formato_org"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "tipo_txt"
  end

  add_index "imports", ["tipo_clase", "fecha_pago", "created_at"], name: "index_imports_on_tipo_clase_and_fecha_pago_and_created_at", using: :btree

  create_table "junta", force: true do |t|
    t.string   "base_id"
    t.string   "secretaria_general"
    t.date     "inicio_gestion"
    t.date     "fin_gestion"
    t.string   "numero_celular"
    t.string   "email"
    t.text     "descripcion"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "junta", ["base_id"], name: "index_junta_on_base_id", using: :btree

  create_table "pagos", force: true do |t|
    t.integer "enfermera_id"
    t.decimal "monto",          precision: 8, scale: 2
    t.date    "mes_cotizacion"
    t.string  "base"
    t.string  "generado_por"
    t.string  "archivo"
    t.string  "status"
  end

  add_index "pagos", ["mes_cotizacion", "base"], name: "index_pagos_on_mes_cotizacion_and_base", using: :btree

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
