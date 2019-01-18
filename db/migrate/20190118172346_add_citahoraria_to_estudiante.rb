class AddCitahorariaToEstudiante < ActiveRecord::Migration[5.2]
  def change
	add_reference :estudiantes, :citahoraria, index: true
	add_foreign_key :estudiantes, :citahorarias, on_delete: :nullify,  on_update: :cascade 
  end
end
