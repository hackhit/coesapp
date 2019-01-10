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

ActiveRecord::Schema.define(version: 2019_01_04_041749) do

  create_table "administradores", primary_key: "usuario_id", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "rol", null: false
    t.string "departamento_id"
    t.string "escuela_id"
    t.index ["departamento_id"], name: "index_administradores_on_departamento_id"
    t.index ["escuela_id"], name: "index_administradores_on_escuela_id"
    t.index ["usuario_id"], name: "index_administradores_on_usuario_id"
  end

  create_table "asignaturas", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "descripcion"
    t.integer "anno"
    t.integer "orden"
    t.integer "calificacion", default: 0
    t.boolean "activa", default: false
    t.string "departamento_id", null: false
    t.string "catedra_id", null: false
    t.string "tipoasignatura_id", null: false
    t.string "id_uxxi"
    t.integer "creditos"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["catedra_id"], name: "index_asignaturas_on_catedra_id"
    t.index ["departamento_id"], name: "index_asignaturas_on_departamento_id"
    t.index ["id"], name: "index_asignaturas_on_id"
    t.index ["tipoasignatura_id"], name: "index_asignaturas_on_tipoasignatura_id"
  end

  create_table "carteleras", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "contenido"
    t.boolean "activa", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "catedradepartamentos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "departamento_id"
    t.string "catedra_id"
    t.integer "orden"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["catedra_id", "departamento_id"], name: "index_catedradepartamentos_on_catedra_id_and_departamento_id", unique: true
    t.index ["catedra_id"], name: "index_catedradepartamentos_on_catedra_id"
    t.index ["departamento_id", "catedra_id"], name: "index_catedradepartamentos_on_departamento_id_and_catedra_id", unique: true
    t.index ["departamento_id"], name: "index_catedradepartamentos_on_departamento_id"
  end

  create_table "catedras", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "descripcion"
    t.integer "orden"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_catedras_on_id"
  end

  create_table "citas_horarias", primary_key: "estudiante_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "fecha", null: false
    t.string "hora"
    t.index ["estudiante_id"], name: "index_citas_horarias_on_estudiante_id"
  end

  create_table "combinaciones", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "estudiante_id"
    t.string "periodo_id"
    t.string "idioma1_id"
    t.string "idioma2_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estudiante_id", "periodo_id"], name: "index_combinaciones_on_estudiante_id_and_periodo_id", unique: true
    t.index ["estudiante_id"], name: "index_combinaciones_on_estudiante_id"
    t.index ["idioma1_id"], name: "index_combinaciones_on_idioma1_id"
    t.index ["idioma2_id"], name: "index_combinaciones_on_idioma2_id"
    t.index ["periodo_id", "estudiante_id"], name: "index_combinaciones_on_periodo_id_and_estudiante_id", unique: true
    t.index ["periodo_id"], name: "index_combinaciones_on_periodo_id"
  end

  create_table "departamentos", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "descripcion"
    t.string "escuela_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["escuela_id"], name: "index_departamentos_on_escuela_id"
    t.index ["id"], name: "index_departamentos_on_id"
  end

  create_table "escuelas", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_escuelas_on_id"
  end

  create_table "estudiantes", primary_key: "usuario_id", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "tipo_estado_inscripcion_id"
    t.string "escuela_id", null: false
    t.boolean "activo", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["escuela_id"], name: "index_estudiantes_on_escuela_id"
    t.index ["tipo_estado_inscripcion_id"], name: "index_estudiantes_on_tipo_estado_inscripcion_id"
    t.index ["usuario_id"], name: "index_estudiantes_on_usuario_id"
  end

  create_table "historialplanes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "estudiante_id"
    t.string "periodo_id"
    t.string "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estudiante_id", "periodo_id"], name: "index_unique", unique: true
    t.index ["estudiante_id"], name: "index_historialplanes_on_estudiante_id"
    t.index ["periodo_id"], name: "index_historialplanes_on_periodo_id"
    t.index ["plan_id"], name: "index_historialplanes_on_plan_id"
  end

  create_table "inscripcionsecciones", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "seccion_id"
    t.string "estudiante_id"
    t.string "tipo_estado_calificacion_id"
    t.string "tipo_estado_inscripcion_id"
    t.string "tipoasignatura_id"
    t.float "primera_calificacion"
    t.float "segunda_calificacion"
    t.float "tercera_calificacion"
    t.float "calificacion_final"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estudiante_id", "seccion_id"], name: "index_inscripcionsecciones_on_estudiante_id_and_seccion_id", unique: true
    t.index ["estudiante_id"], name: "index_inscripcionsecciones_on_estudiante_id"
    t.index ["seccion_id", "estudiante_id"], name: "index_inscripcionsecciones_on_seccion_id_and_estudiante_id", unique: true
    t.index ["seccion_id"], name: "index_inscripcionsecciones_on_seccion_id"
    t.index ["tipo_estado_calificacion_id"], name: "index_inscripcionsecciones_on_tipo_estado_calificacion_id"
    t.index ["tipo_estado_inscripcion_id"], name: "index_inscripcionsecciones_on_tipo_estado_inscripcion_id"
    t.index ["tipoasignatura_id"], name: "index_inscripcionsecciones_on_tipoasignatura_id"
  end

  create_table "parametros_generales", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_parametros_generales_on_id"
  end

  create_table "periodos", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "inicia"
    t.date "culmina"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_periodos_on_id"
  end

  create_table "planes", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "descripcion"
    t.string "escuela_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["escuela_id"], name: "index_planes_on_escuela_id"
    t.index ["id"], name: "index_planes_on_id"
  end

  create_table "profesores", primary_key: "usuario_id", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "departamento_id"
    t.index ["departamento_id"], name: "index_profesores_on_departamento_id"
    t.index ["usuario_id"], name: "index_profesores_on_usuario_id"
  end

  create_table "seccion_profesores_secundarios", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "profesor_id"
    t.bigint "seccion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profesor_id", "seccion_id"], name: "seccion_secundarios_on_profesor_id_and_seccion_id", unique: true
    t.index ["profesor_id"], name: "index_seccion_profesores_secundarios_on_profesor_id"
    t.index ["seccion_id", "profesor_id"], name: "seccion_secundarios_on_seccion_id_and_profesor_id", unique: true
    t.index ["seccion_id"], name: "index_seccion_profesores_secundarios_on_seccion_id"
  end

  create_table "secciones", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "numero"
    t.string "asignatura_id"
    t.string "periodo_id"
    t.string "profesor_id"
    t.boolean "calificada"
    t.integer "capacidad"
    t.integer "tipo", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asignatura_id"], name: "index_secciones_on_asignatura_id"
    t.index ["numero", "periodo_id", "asignatura_id"], name: "index_secciones_on_numero_and_periodo_id_and_asignatura_id", unique: true
    t.index ["periodo_id"], name: "index_secciones_on_periodo_id"
    t.index ["profesor_id"], name: "index_secciones_on_profesor_id"
  end

  create_table "tipo_estado_calificaciones", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_tipo_estado_calificaciones_on_id"
  end

  create_table "tipo_estado_inscripciones", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_tipo_estado_inscripciones_on_id"
  end

  create_table "tipoasignaturas", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_tipoasignaturas_on_id"
  end

  create_table "usuarios", primary_key: "ci", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nombres"
    t.string "apellidos"
    t.string "email"
    t.string "telefono_habitacion"
    t.string "telefono_movil"
    t.string "password"
    t.integer "sexo", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ci"], name: "index_usuarios_on_ci"
  end

  add_foreign_key "administradores", "departamentos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "administradores", "escuelas", on_update: :cascade, on_delete: :nullify
  add_foreign_key "administradores", "usuarios", primary_key: "ci", on_update: :cascade, on_delete: :cascade
  add_foreign_key "asignaturas", "catedras", on_update: :cascade, on_delete: :cascade
  add_foreign_key "asignaturas", "departamentos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "asignaturas", "tipoasignaturas", on_update: :cascade, on_delete: :cascade
  add_foreign_key "catedradepartamentos", "catedras", on_update: :cascade, on_delete: :cascade
  add_foreign_key "catedradepartamentos", "departamentos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "combinaciones", "departamentos", column: "idioma1_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "combinaciones", "departamentos", column: "idioma2_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "combinaciones", "estudiantes", primary_key: "usuario_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "combinaciones", "periodos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "departamentos", "escuelas", on_update: :cascade, on_delete: :cascade
  add_foreign_key "estudiantes", "escuelas", on_update: :cascade, on_delete: :cascade
  add_foreign_key "estudiantes", "usuarios", primary_key: "ci", on_update: :cascade, on_delete: :cascade
  add_foreign_key "historialplanes", "estudiantes", primary_key: "usuario_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "historialplanes", "periodos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "historialplanes", "planes", on_update: :cascade, on_delete: :cascade
  add_foreign_key "inscripcionsecciones", "estudiantes", primary_key: "usuario_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "inscripcionsecciones", "secciones", on_update: :cascade, on_delete: :cascade
  add_foreign_key "inscripcionsecciones", "tipo_estado_calificaciones", on_update: :cascade, on_delete: :nullify
  add_foreign_key "inscripcionsecciones", "tipo_estado_inscripciones", on_update: :cascade, on_delete: :nullify
  add_foreign_key "inscripcionsecciones", "tipoasignaturas", on_update: :cascade, on_delete: :cascade
  add_foreign_key "planes", "escuelas", on_update: :cascade, on_delete: :cascade
  add_foreign_key "profesores", "departamentos", on_update: :cascade, on_delete: :nullify
  add_foreign_key "profesores", "usuarios", primary_key: "ci", on_update: :cascade, on_delete: :cascade
  add_foreign_key "seccion_profesores_secundarios", "profesores", primary_key: "usuario_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "seccion_profesores_secundarios", "secciones", on_update: :cascade, on_delete: :cascade
  add_foreign_key "secciones", "asignaturas", on_update: :cascade, on_delete: :cascade
  add_foreign_key "secciones", "periodos", on_update: :cascade, on_delete: :cascade
  add_foreign_key "secciones", "profesores", primary_key: "usuario_id", on_update: :cascade, on_delete: :cascade
end
