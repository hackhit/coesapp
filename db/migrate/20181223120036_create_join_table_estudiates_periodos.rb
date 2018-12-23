class CreateJoinTableEstudiatesPeriodos < ActiveRecord::Migration[5.2]
  def change
    create_join_table :estudiantes, :periodos, table_name: :combinaciones do |t|
      t.references :estudiante, type: :string
      t.references :periodo, type: :string
      t.index [:estudiante_id, :periodo_id], unique: true
      t.index [:periodo_id, :estudiante_id], unique: true
      t.references :idioma1, references: :departamentos, type: :string
      t.references :idioma2, references: :departamentos, type: :string
 
    end
    add_foreign_key :combinaciones, :estudiantes, primary_key: :usuario_id, on_delete: :cascade,  on_update: :cascade
    add_foreign_key :combinaciones, :periodos, on_delete: :cascade,  on_update: :cascade
    add_foreign_key :combinaciones, :departamentos, column: :idioma1_id, on_delete: :cascade,  on_update: :cascade
    add_foreign_key :combinaciones, :departamentos, column: :idioma2_id, on_delete: :cascade,  on_update: :cascade
  end
end
