class CreateProfesor < ActiveRecord::Migration[5.2]
  def change
    create_table :profesores, id: false do |t|
		t.references :usuario, null: false, type: :string, primary_key: true
		t.references :departamento, type: :string
    end
    add_foreign_key :profesores, :usuarios, column: :usuario_id, primary_key: :ci, on_delete: :cascade,  on_update: :cascade
    add_foreign_key :profesores, :departamentos, on_delete: :nullify,  on_update: :cascade

  end
end
