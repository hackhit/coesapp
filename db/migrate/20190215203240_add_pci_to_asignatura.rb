class AddPciToAsignatura < ActiveRecord::Migration[5.2]
  def change
  	add_column :asignaturas, :pci, :boolean, null: false, default: false
  end
end
