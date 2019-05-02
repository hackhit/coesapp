class RemoveEscuelaIdToEstudiante < ActiveRecord::Migration[5.2]
  def change

    remove_foreign_key :estudiantes, :escuelas
    remove_column :estudiantes, :escuela_id

  end
end
