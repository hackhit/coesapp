class AddEscuelaIdToInscripcionseccion < ActiveRecord::Migration[5.2]
  def change
    add_reference :inscripcionsecciones, :escuela, type: :string, index: true
	add_column :inscripcionsecciones, :pci, :boolean, default: false
  end
end
