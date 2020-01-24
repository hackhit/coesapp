class AddRetiroAndCambioSeccionToEscuela < ActiveRecord::Migration[5.2]
  def change
  	add_column :escuelas, :habilitar_retiro_asignaturas, :boolean, default: true
  	add_column :escuelas, :habilitar_cambio_seccion, :boolean, default: true
  end
end