class CreateTableEscuelaestudiante < ActiveRecord::Migration[5.2]
  def change
    create_table :escuelaestudiantes, id: false do |t|
      t.references :escuela, type: :string#, foreign_key: true
      t.references :estudiante, type: :string#, foreign_key: true, index: true, primary_key: 'usuario_id'
      t.index [:estudiante_id, :escuela_id], unique: true
      t.index [:escuela_id, :estudiante_id], unique: true
      t.timestamps

    end
    add_foreign_key :escuelaestudiantes, :estudiantes, primary_key: :usuario_id, on_delete: :cascade,  on_update: :cascade
    add_foreign_key :escuelaestudiantes, :escuelas, on_delete: :cascade,  on_update: :cascade


  end
end
