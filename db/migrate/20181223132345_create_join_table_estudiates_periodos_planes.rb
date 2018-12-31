class CreateJoinTableEstudiatesPeriodosPlanes < ActiveRecord::Migration[5.2]
  def change
    create_table 'historialplanes' do |t|
      t.references :estudiante, type: :string
      t.references :periodo, type: :string
      t.references :plan, type: :string
      t.index [:estudiante_id, :periodo_id], unique: true, name: 'index_unique'
      t.timestamps
      
    end
    add_foreign_key :historialplanes, :estudiantes, primary_key: :usuario_id, on_delete: :cascade, on_update: :cascade
    add_foreign_key :historialplanes, :periodos, on_delete: :cascade, on_update: :cascade
    add_foreign_key :historialplanes, :planes, on_delete: :cascade, on_update: :cascade
  end
end
