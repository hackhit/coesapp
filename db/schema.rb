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

ActiveRecord::Schema.define(version: 2019_02_07_132203) do

  create_table "actividad", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "instrucciones", null: false
    t.integer "cantidad_preguntas", limit: 1
    t.string "curso_idioma_id", limit: 10, null: false
    t.string "curso_tipo_categoria_id", limit: 10, null: false
    t.string "curso_tipo_nivel_id", limit: 10, null: false
    t.string "tipo_actividad_id", limit: 20, null: false
    t.index ["curso_idioma_id", "curso_tipo_categoria_id", "curso_tipo_nivel_id"], name: "fk_actividad_curso1_idx"
    t.index ["tipo_actividad_id"], name: "fk_actividad_tipo_actividad1_idx"
  end

  create_table "adjunto", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "archivo"
    t.integer "actividad_id", null: false
    t.string "original_filename"
    t.index ["actividad_id"], name: "fk_adjunto_actividad1_idx"
  end

  create_table "administrador", primary_key: "usuario_ci", id: :string, limit: 20, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "tipo_rol_id"
    t.string "tipo_administrador_id"
    t.index ["usuario_ci"], name: "administrador_usuario_ci"
  end

  create_table "administradores", primary_key: "usuario_id", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "rol", null: false
    t.string "departamento_id"
    t.string "escuela_id"
    t.index ["departamento_id"], name: "index_administradores_on_departamento_id"
    t.index ["escuela_id"], name: "index_administradores_on_escuela_id"
    t.index ["usuario_id"], name: "index_administradores_on_usuario_id"
  end

  create_table "archivo", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nombre"
    t.text "url"
    t.string "bloque_horario_id", limit: 10
    t.string "idioma_id", limit: 10
    t.string "tipo_nivel_id", limit: 10
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "aula", id: :string, limit: 20, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "tipo_ubicacion_id", limit: 10, null: false
    t.string "descripcion"
    t.integer "conjunto_disponible", default: 1, null: false
    t.integer "usada", default: 0, null: false
    t.index ["tipo_ubicacion_id"], name: "fk_aula_tipo_ubicacion1"
  end

  create_table "bitacora", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "fecha", null: false
    t.text "descripcion", null: false
    t.string "usuario_ci", limit: 20
    t.string "estudiante_usuario_ci", limit: 20
    t.string "administrador_usuario_ci", limit: 20
    t.string "ip_origen", limit: 45
    t.index ["administrador_usuario_ci"], name: "fk_bitacora_administrador1"
    t.index ["estudiante_usuario_ci"], name: "fk_bitacora_estudiante1"
    t.index ["usuario_ci"], name: "fk_bitacora_usuario1"
  end

  create_table "bitacoras", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "comentario"
    t.string "descripcion"
    t.string "usuario_id"
    t.string "id_objeto"
    t.string "tipo_objeto"
    t.string "ip_origen"
    t.integer "tipo", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["usuario_id"], name: "index_bitacoras_on_usuario_id"
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

  create_table "citahorarias", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "fecha", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "escuelaperiodos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "periodo_id"
    t.string "escuela_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["escuela_id", "periodo_id"], name: "index_escuelaperiodos_on_escuela_id_and_periodo_id", unique: true
    t.index ["escuela_id"], name: "index_escuelaperiodos_on_escuela_id"
    t.index ["periodo_id", "escuela_id"], name: "index_escuelaperiodos_on_periodo_id_and_escuela_id", unique: true
    t.index ["periodo_id"], name: "index_escuelaperiodos_on_periodo_id"
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
    t.bigint "citahoraria_id"
    t.index ["citahoraria_id"], name: "index_estudiantes_on_citahoraria_id"
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

  create_table "inscripcionperiodos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "periodo_id", null: false
    t.string "estudiante_id", null: false
    t.string "tipo_estado_inscripcion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estudiante_id", "periodo_id"], name: "index_inscripcionperiodos_on_estudiante_id_and_periodo_id", unique: true
    t.index ["estudiante_id"], name: "index_inscripcionperiodos_on_estudiante_id"
    t.index ["periodo_id", "estudiante_id"], name: "index_inscripcionperiodos_on_periodo_id_and_estudiante_id", unique: true
    t.index ["periodo_id"], name: "index_inscripcionperiodos_on_periodo_id"
    t.index ["tipo_estado_inscripcion_id"], name: "index_inscripcionperiodos_on_tipo_estado_inscripcion_id"
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

  create_table "inscripcionsecciones_copy", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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
    t.integer "tipo", null: false
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
    t.string "tipo_seccion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asignatura_id"], name: "index_secciones_on_asignatura_id"
    t.index ["numero", "periodo_id", "asignatura_id"], name: "index_secciones_on_numero_and_periodo_id_and_asignatura_id", unique: true
    t.index ["periodo_id"], name: "index_secciones_on_periodo_id"
    t.index ["profesor_id"], name: "index_secciones_on_profesor_id"
    t.index ["tipo_seccion_id"], name: "index_secciones_on_tipo_seccion_id"
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

  create_table "tipo_secciones", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_tipo_secciones_on_id"
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

  add_foreign_key "actividad", "curso", column: "curso_idioma_id", primary_key: "idioma_id", name: "actividad_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "actividad", "curso", column: "curso_tipo_categoria_id", primary_key: "tipo_categoria_id", name: "actividad_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "actividad", "curso", column: "curso_tipo_nivel_id", primary_key: "tipo_nivel_id", name: "actividad_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "actividad", "tipo_actividad", name: "actividad_ibfk_2"
  add_foreign_key "adjunto", "actividad", name: "adjunto_ibfk_1"
  add_foreign_key "administrador", "usuario", column: "usuario_ci", primary_key: "ci", name: "administrador_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "administradores", "departamentos", name: "administradores_ibfk_3", on_update: :cascade, on_delete: :cascade
  add_foreign_key "administradores", "escuelas", name: "administradores_ibfk_1", on_update: :cascade, on_delete: :nullify
  add_foreign_key "administradores", "usuarios", primary_key: "ci", name: "administradores_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "asignaturas", "catedras", name: "asignaturas_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "asignaturas", "departamentos", name: "asignaturas_ibfk_3", on_update: :cascade, on_delete: :cascade
  add_foreign_key "asignaturas", "tipoasignaturas", name: "asignaturas_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "aula", "tipo_ubicacion", name: "aula_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "catedradepartamentos", "catedras", name: "catedradepartamentos_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "catedradepartamentos", "departamentos", name: "catedradepartamentos_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "combinaciones", "departamentos", column: "idioma1_id", name: "combinaciones_ibfk_3", on_update: :cascade, on_delete: :cascade
  add_foreign_key "combinaciones", "departamentos", column: "idioma2_id", name: "combinaciones_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "combinaciones", "estudiantes", primary_key: "usuario_id", name: "combinaciones_ibfk_4", on_update: :cascade, on_delete: :cascade
  add_foreign_key "combinaciones", "periodos", name: "combinaciones_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "departamentos", "escuelas", name: "departamentos_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "escuelaperiodos", "escuelas", name: "escuelaperiodos_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "escuelaperiodos", "periodos", name: "escuelaperiodos_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "estudiantes", "citahorarias", name: "estudiantes_ibfk_1", on_update: :cascade, on_delete: :nullify
  add_foreign_key "estudiantes", "escuelas", name: "estudiantes_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "estudiantes", "usuarios", primary_key: "ci", name: "estudiantes_ibfk_3", on_update: :cascade, on_delete: :cascade
  add_foreign_key "historialplanes", "estudiantes", primary_key: "usuario_id", name: "historialplanes_ibfk_3", on_update: :cascade, on_delete: :cascade
  add_foreign_key "historialplanes", "periodos", name: "historialplanes_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "historialplanes", "planes", name: "historialplanes_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "inscripcionperiodos", "estudiantes", primary_key: "usuario_id", name: "inscripcionperiodos_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "inscripcionperiodos", "periodos", name: "inscripcionperiodos_ibfk_3", on_update: :cascade, on_delete: :cascade
  add_foreign_key "inscripcionperiodos", "tipo_estado_inscripciones", name: "inscripcionperiodos_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "inscripcionsecciones", "estudiantes", primary_key: "usuario_id", name: "inscripcionsecciones_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "inscripcionsecciones", "secciones", name: "inscripcionsecciones_ibfk_4", on_update: :cascade, on_delete: :cascade
  add_foreign_key "inscripcionsecciones", "tipo_estado_calificaciones", name: "inscripcionsecciones_ibfk_3", on_update: :cascade, on_delete: :nullify
  add_foreign_key "inscripcionsecciones", "tipo_estado_inscripciones", name: "inscripcionsecciones_ibfk_5", on_update: :cascade, on_delete: :nullify
  add_foreign_key "inscripcionsecciones", "tipoasignaturas", name: "inscripcionsecciones_ibfk_1", on_update: :cascade, on_delete: :nullify
  add_foreign_key "inscripcionsecciones_copy", "estudiantes", primary_key: "usuario_id", name: "inscripcionsecciones_copy_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "inscripcionsecciones_copy", "secciones", name: "inscripcionsecciones_copy_ibfk_4", on_update: :cascade, on_delete: :cascade
  add_foreign_key "inscripcionsecciones_copy", "tipo_estado_calificaciones", name: "inscripcionsecciones_copy_ibfk_3", on_update: :cascade, on_delete: :nullify
  add_foreign_key "inscripcionsecciones_copy", "tipo_estado_inscripciones", name: "inscripcionsecciones_copy_ibfk_5", on_update: :cascade, on_delete: :nullify
  add_foreign_key "inscripcionsecciones_copy", "tipoasignaturas", name: "inscripcionsecciones_copy_ibfk_1", on_update: :cascade, on_delete: :nullify
  add_foreign_key "planes", "escuelas", name: "planes_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "profesores", "departamentos", name: "profesores_ibfk_1", on_update: :cascade, on_delete: :nullify
  add_foreign_key "profesores", "usuarios", primary_key: "ci", name: "profesores_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "seccion_profesores_secundarios", "profesores", primary_key: "usuario_id", name: "seccion_profesores_secundarios_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "seccion_profesores_secundarios", "secciones", name: "seccion_profesores_secundarios_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "secciones", "asignaturas", name: "secciones_ibfk_2", on_update: :cascade, on_delete: :cascade
  add_foreign_key "secciones", "periodos", name: "secciones_ibfk_3", on_update: :cascade, on_delete: :cascade
  add_foreign_key "secciones", "profesores", primary_key: "usuario_id", name: "secciones_ibfk_4", on_update: :cascade, on_delete: :cascade
  add_foreign_key "secciones", "tipo_secciones", name: "secciones_ibfk_1", on_update: :cascade, on_delete: :cascade
end
