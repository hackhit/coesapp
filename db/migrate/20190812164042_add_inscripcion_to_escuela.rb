class AddInscripcionToEscuela < ActiveRecord::Migration[5.2]
  def change
  	add_column :escuelas, :inscripcion_abierta, :boolean, default: true
  end
end
