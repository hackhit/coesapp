class CreateJoinTableEstudiantesSecciones < ActiveRecord::Migration[5.2]
  def change
    create_table :inscripcionsecciones do |t|
      t.references :seccion
      t.references :estudiante, type: :string
      t.references :tipo_estado_calificacion, type: :string
      t.references :tipo_estado_inscripcion, type: :string
      t.references :tipoasignatura, type: :string
      t.index [:estudiante_id, :seccion_id], unique: true
      t.index [:seccion_id, :estudiante_id], unique: true
      t.float :primera_calificacion
      t.float :segunda_calificacion
      t.float :tercera_calificacion
      t.float :calificacion_final
      t.timestamps
    end
    add_foreign_key :inscripcionsecciones, :estudiantes, primary_key: :usuario_id, on_delete: :cascade,  on_update: :cascade
    add_foreign_key :inscripcionsecciones, :secciones, on_delete: :cascade,  on_update: :cascade
    add_foreign_key :inscripcionsecciones, :tipo_estado_inscripciones, on_delete: :nullify,  on_update: :cascade
    add_foreign_key :inscripcionsecciones, :tipo_estado_calificaciones, on_delete: :nullify,  on_update: :cascade
    add_foreign_key :inscripcionsecciones, :tipoasignaturas, on_delete: :nullify,  on_update: :cascade

  end
end
