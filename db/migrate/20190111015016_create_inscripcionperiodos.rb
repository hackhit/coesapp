class CreateInscripcionperiodos < ActiveRecord::Migration[5.2]
  def change
    create_table :inscripcionperiodos do |t|
      t.references :periodo, type: :string, null: false
      t.references :estudiante, type: :string, null: false
      t.references :tipo_estado_inscripcion, type: :string, null: false
      t.index [:estudiante_id, :periodo_id], unique: true
      t.index [:periodo_id, :estudiante_id], unique: true

      t.timestamps
    end
    add_foreign_key :inscripcionperiodos, :estudiantes, primary_key: :usuario_id, on_delete: :cascade,  on_update: :cascade
    add_foreign_key :inscripcionperiodos, :periodos, on_delete: :cascade,  on_update: :cascade
    add_foreign_key :inscripcionperiodos, :tipo_estado_inscripciones, on_delete: :cascade,  on_update: :cascade
  end
end
