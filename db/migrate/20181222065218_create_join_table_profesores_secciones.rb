class CreateJoinTableProfesoresSecciones < ActiveRecord::Migration[5.2]
  def change
    create_join_table :profesores, :secciones, table_name: :seccion_profesores_secundarios do |t|
      t.references :profesor, type: :string
      t.references :seccion
      t.index [:profesor_id, :seccion_id], unique: true, name: 'seccion_secundarios_on_profesor_id_and_seccion_id'
      t.index [:seccion_id, :profesor_id], unique: true, name: 'seccion_secundarios_on_seccion_id_and_profesor_id'
    end
    add_foreign_key :seccion_profesores_secundarios, :secciones, on_delete: :cascade,  on_update: :cascade
    add_foreign_key :seccion_profesores_secundarios, :profesores, on_delete: :cascade,  on_update: :cascade, primary_key: :usuario_id

  end
end
