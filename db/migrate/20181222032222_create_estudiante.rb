class CreateEstudiante < ActiveRecord::Migration[5.2]
  def change
    create_table :estudiantes, id: false do |t|
		t.references :usuario, null: false, type: :string, primary_key: true
		t.references :tipo_estado_inscripcion, type: :string, index: true
		t.references :escuela, type: :string, null: false
		t.timestamps
    end
    add_foreign_key :estudiantes, :usuarios, column: :usuario_id, primary_key: :ci, on_delete: :cascade,  on_update: :cascade
    add_foreign_key :estudiantes, :escuelas, type: :string, on_delete: :cascade, on_update: :cascade, index: true

  end
end
