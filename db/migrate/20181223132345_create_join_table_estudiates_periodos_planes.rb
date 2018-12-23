class CreateJoinTableEstudiatesPeriodosPlanes < ActiveRecord::Migration[5.2]
  def change
    create_table :historiales_planes do |t|
      t.references :estudiante, type: :string
      t.references :periodo, type: :string
      t.references :plan, type: :string
      t.index [:estudiante_id, :periodo_id, :plan_id], unique: true, name: 'index_unique'
    end
    add_foreign_key :historiales_planes, :estudiantes, primary_key: :usuario_id, on_delete: :cascade, on_update: :cascade
    add_foreign_key :historiales_planes, :periodos, on_delete: :cascade, on_update: :cascade
    add_foreign_key :historiales_planes, :planes, on_delete: :cascade, on_update: :cascade
  end
end
