class CreateEstudiante < ActiveRecord::Migration[5.2]
  def change
    create_table :estudiantes, id: false do |t|
		t.references :usuario, null: false, type: :string, primary_key: true
    end
    add_foreign_key :estudiantes, :usuarios, column: :usuario_id, primary_key: :ci, on_delete: :cascade,  on_update: :cascade
  end
end
