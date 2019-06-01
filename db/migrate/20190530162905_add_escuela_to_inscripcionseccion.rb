class AddEscuelaToInscripcionseccion < ActiveRecord::Migration[5.2]
  def change
	# add_reference :inscripcionsecciones, :escuela, type: :string, index: true
	add_column :inscripcionsecciones, :pci_escuela_id, :string, index: true
	add_foreign_key :inscripcionsecciones, :escuelas, on_delete: :nullify,  on_update: :cascade, column: :pci_escuela_id
  end
end