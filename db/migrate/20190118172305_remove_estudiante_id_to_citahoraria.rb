class RemoveEstudianteIdToCitahoraria < ActiveRecord::Migration[5.2]
  def change
  	remove_foreign_key :citahorarias, :estudiantes
  	remove_column :citahorarias, :estudiante_id
  end

end
